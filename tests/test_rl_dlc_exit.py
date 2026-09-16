"""Run the actual DLC shell entrypoint with local command doubles only."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


class DLCExitTests(unittest.TestCase):
    def run_entrypoint(self, training_exit, cleanup_exit):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            commands = root / 'bin'
            commands.mkdir()
            source = root / 'source'
            (source / 'rl').mkdir(parents=True)
            trace = root / 'events.jsonl'
            command = (
                '#!' + sys.executable + '\n'
                'import json, os, sys\n'
                'from pathlib import Path\n'
                'name=Path(sys.argv[0]).name\n'
                'with open(os.environ["EXIT_TRACE"], "a") as stream:\n'
                ' stream.write(json.dumps([name, sys.argv[1:]]) + "\\n")\n'
                'if name == "python3" and "-c" in sys.argv:\n'
                ' print(8)\n'
                'if "--cleanup" in sys.argv:\n'
                ' sys.exit(int(os.environ["FIXTURE_CLEANUP_EXIT"]))\n'
            )
            for name in ('ray', 'python3'):
                path = commands / name
                path.write_text(command)
                path.chmod(0o755)
            (source / 'rl/run_prover_rl.sh').write_text(
                '#!/bin/bash\necho "training command executed"\n'
                'exit "${FIXTURE_TRAINING_EXIT}"\n'
            )
            env = {
                **os.environ,
                'PATH': str(commands) + os.pathsep + os.environ['PATH'],
                'CODEPROVER_ROOT': str(source), 'MILES_ROOT': str(root),
                'RUN_ROOT': str(root), 'RUN_ID': 'exit-fixture',
                'ATTEMPT_ID': 'attempt-fixture', 'MLP_WORKER_RACK_RANK_INDEX': '0',
                'MLP_WORKER_NUM': '1', 'MLP_WORKER_GPU': '8',
                'E2B_WARM_POOL_SIZE': '1', 'EXIT_TRACE': str(trace),
                'FIXTURE_TRAINING_EXIT': str(training_exit),
                'FIXTURE_CLEANUP_EXIT': str(cleanup_exit),
            }
            result = subprocess.run(
                ['bash', str(Path(__file__).parents[1] / 'rl/run_dlc.sh')],
                env=env, capture_output=True, text=True, timeout=5,
            )
            self.assertEqual(result.returncode, training_exit, result.stderr)
            self.assertIn('training command executed', result.stdout)
            run = root / 'exit-fixture'
            done = run / 'cluster.done.attempt-fixture'
            self.assertEqual(done.read_text().strip(), str(training_exit))
            log = run / 'attempt-logs/attempt-fixture.master.log'
            self.assertIn('training command executed', log.read_text())
            events = [json.loads(line) for line in trace.read_text().splitlines()]
            stops = [i for i, event in enumerate(events) if event == ['ray', ['stop', '--force']]]
            cleans = [i for i, event in enumerate(events)
                      if event == ['python3', ['-m', 'rl.warm_pool', '--cleanup']]]
            self.assertEqual(len(stops), 1)
            self.assertEqual(len(cleans), 1)
            self.assertLess(stops[0], cleans[0])
            if cleanup_exit:
                self.assertIn('warm-pool exit cleanup incomplete', result.stderr)

    def test_training_failure_preserves_exit_status_after_cleanup(self):
        self.run_entrypoint(training_exit=17, cleanup_exit=0)

    def test_cleanup_failure_does_not_replace_training_failure(self):
        self.run_entrypoint(training_exit=17, cleanup_exit=9)

    def test_success_publishes_success_after_cleanup(self):
        self.run_entrypoint(training_exit=0, cleanup_exit=0)


if __name__ == '__main__':
    unittest.main()
