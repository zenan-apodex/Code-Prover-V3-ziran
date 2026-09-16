"""A model-only or half-written checkpoint must not silently reset the sampler."""
import importlib.util
from pathlib import Path
import sys
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch

import torch


class BaseSource:
    def __init__(self, args):
        self.args = args
        self.buffer = []
        self.sample_offset = self.epoch_id = self.sample_group_index = self.sample_index = 0
        self.metadata = {}
        self.dataset = SimpleNamespace(shuffle=lambda epoch: None)
    def save(self, rollout_id):
        p = Path(self.args.save) / 'rollout' / f'global_dataset_state_dict_{rollout_id}.pt'
        p.parent.mkdir(parents=True, exist_ok=True)
        torch.save({key: getattr(self, key) for key in
                    ('sample_offset', 'epoch_id', 'sample_group_index', 'sample_index', 'metadata')}, p)
    def load(self, rollout_id):
        if self.args.load is None:
            return
        p = Path(self.args.load) / 'rollout' / f'global_dataset_state_dict_{rollout_id}.pt'
        if p.is_file():
            for key, value in torch.load(p, weights_only=True).items():
                setattr(self, key, value)


class ResumeStateTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name)
        self.args = SimpleNamespace(load=self.tmp.name, save=self.tmp.name,
            rollout_global_dataset=True, rollout_shuffle=False,
            prover_reset_rollout_data_state=False, start_rollout_id=None,
            prover_async_pause_timeout_sec=1)
        path = Path(__file__).parents[1] / 'rl/persistent_data_source.py'
        spec = importlib.util.spec_from_file_location('_resume_state', path)
        module = importlib.util.module_from_spec(spec)
        with patch.dict(sys.modules, {'miles.rollout.data_source':
                                     SimpleNamespace(RolloutDataSourceWithBuffer=BaseSource)}):
            spec.loader.exec_module(module)
        self.source = module.PersistentRolloutDataSource(self.args)
        self.buffer = self.source._buffer_path(self.tmp.name, 24)
        self.buffer.parent.mkdir(exist_ok=True)
        self.cursor = self.buffer.parent / 'global_dataset_state_dict_24.pt'

    def test_missing_buffer_rejects_resume_with_or_without_cursor(self):
        for cursor_present in (False, True):
            if cursor_present:
                torch.save({'sample_index': 8, 'sample_offset': 1}, self.cursor)
            with self.subTest(cursor_present=cursor_present):
                with self.assertRaisesRegex(FileNotFoundError, 'sampling checkpoint'):
                    self.source.load(24)

    def test_legacy_buffer_without_cursor_rejects_resume(self):
        torch.save([], self.buffer)
        with self.assertRaisesRegex(FileNotFoundError, 'cursor'):
            self.source.load(24)

    def test_complete_legacy_pair_still_loads(self):
        torch.save([], self.buffer)
        torch.save({'sample_index': 8, 'sample_offset': 1, 'epoch_id': 2,
                    'sample_group_index': 1, 'metadata': {}}, self.cursor)
        self.source.load(24)
        self.assertEqual((self.source.sample_index, self.source.sample_offset), (8, 1))

    def test_complete_empty_checkpoint_still_loads(self):
        with patch.dict(sys.modules, {'rl.fully_async_rollout':
                                     SimpleNamespace(get_existing_worker=lambda source: None,
                                                     stop_global_worker=lambda: None)}):
            self.source.save(24)
        self.source.load(24)
        self.assertEqual(self.source.buffer, [])

    def test_initial_weights_and_explicit_reset_do_not_require_sampler_state(self):
        self.source.load(-1)
        self.assertEqual(self.args.start_rollout_id, 0)
        self.args.prover_reset_rollout_data_state = True
        self.source.load(24)
        self.assertEqual(self.source.sample_offset, 0)


if __name__ == '__main__':
    unittest.main()
