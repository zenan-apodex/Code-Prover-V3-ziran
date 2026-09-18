import asyncio
import errno
import json
from pathlib import Path
import tempfile
import time
import unittest
from unittest.mock import AsyncMock, patch

from verifier.comparator.queue import Service, atomic_json, digest, healthy, submit
from verifier.comparator.backend import ComparatorInfrastructureError

ORIGINAL = 'theorem t : True := by\n  -- !benchmark @start proof\n  sorry\n  -- !benchmark @end proof\n'
SOLUTION = ORIGINAL.replace('sorry', 'trivial')

class QueueTests(unittest.IsolatedAsyncioTestCase):
    async def asyncSetUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        self.queue = self.root / 'queue'
        (self.queue / 'requests').mkdir(parents=True)
        self.catalog = self.root / 'catalog.json'
        atomic_json(self.catalog, {digest(ORIGINAL.encode()): {'source': ORIGINAL, 'tasks': ['trusted']}})
        self.service = Service(self.queue, self.catalog, 'image', 2, 60)
        atomic_json(self.queue / 'service.json', {'state':'ready','heartbeat':time.time(),
                    'catalog_sha256':self.service.catalog_sha})

    async def asyncTearDown(self):
        self.tmp.cleanup()

    async def request(self):
        client = asyncio.create_task(submit(ORIGINAL, SOLUTION, queue=self.queue, timeout=5, poll_sec=.01))
        await asyncio.sleep(.02)
        directory = next((self.queue / 'requests').iterdir())
        return client, directory

    async def test_roundtrip_preserves_source_and_identity(self):
        client, directory = await self.request()
        judge = AsyncMock(return_value={'accepted':True,'status':'accepted'})
        with patch('verifier.comparator.queue.judge', judge):
            await self.service.process(directory)
        result = await client
        self.assertTrue(result['accepted'])
        self.assertEqual(judge.call_args.args, (ORIGINAL, SOLUTION))
        self.assertEqual(result['queue_request_id'], directory.name)

    async def test_unknown_original_cannot_be_supplied_by_candidate(self):
        client, directory = await self.request()
        request=json.loads((directory/'request.json').read_text())
        request['original_sha256']='0'*64
        atomic_json(directory/'request.json',request)
        judge=AsyncMock()
        with patch('verifier.comparator.queue.judge',judge):
            await self.service.process(directory)
        with self.assertRaises(ComparatorInfrastructureError): await client
        judge.assert_not_awaited()

    async def test_changed_source_rejected_before_execution(self):
        client, directory = await self.request()
        (directory/'solution.lean').write_text('tampered')
        judge=AsyncMock()
        with patch('verifier.comparator.queue.judge',judge):
            await self.service.process(directory)
        with self.assertRaises(ComparatorInfrastructureError): await client
        judge.assert_not_awaited()

    async def test_backend_failure_retries_same_proof_not_generation(self):
        client, directory = await self.request()
        judge=AsyncMock(side_effect=[RuntimeError('temporary'), {'accepted':False,'status':'rejected'}])
        with patch('verifier.comparator.queue.judge',judge):
            await self.service.process(directory)
        self.assertFalse((await client)['accepted'])
        self.assertEqual(judge.await_count, 2)
        self.assertEqual(judge.call_args_list[0].args,judge.call_args_list[1].args)

    async def test_cancel_is_persisted_and_prevents_execution(self):
        client, directory = await self.request()
        client.cancel()
        with self.assertRaises(asyncio.CancelledError): await client
        self.assertTrue((directory/'cancel.json').exists())
        judge=AsyncMock()
        with patch('verifier.comparator.queue.judge',judge):
            await self.service.process(directory)
        judge.assert_not_awaited()

    async def test_stale_service_fails_before_publication(self):
        atomic_json(self.queue/'service.json', {'state':'ready','heartbeat':time.time()-100})
        with self.assertRaises(ComparatorInfrastructureError):
            await submit(ORIGINAL,SOLUTION,queue=self.queue,timeout=1)
        self.assertEqual(list((self.queue/'requests').iterdir()),[])

    async def test_estale_read_reopens_and_preserves_freshness_checks(self):
        path = self.queue / 'service.json'
        with path.open('rb') as stream, patch.object(Path, 'open', side_effect=[
                OSError(errno.ESTALE, 'Stale file handle'), stream]) as opened, \
                patch('verifier.comparator.queue.time.sleep') as sleep:
            self.assertEqual(healthy(self.queue)['catalog_sha256'], self.service.catalog_sha)
        self.assertEqual(opened.call_count, 2)
        sleep.assert_called_once_with(0.05)
        atomic_json(path, {'state': 'ready', 'heartbeat': time.time() - 100})
        with path.open('rb') as stream, patch.object(Path, 'open', side_effect=[
                OSError(errno.ESTALE, 'Stale file handle'), stream]), \
                patch('verifier.comparator.queue.time.sleep'):
            with self.assertRaises(ComparatorInfrastructureError):
                healthy(self.queue)

    async def test_cpfs_estale_then_eio_recovers_without_relaxing_freshness(self):
        path = self.queue / 'service.json'
        with path.open('rb') as stream, patch.object(Path, 'open', side_effect=[
                OSError(errno.ESTALE, 'Stale file handle'), OSError(errno.EIO, 'Input/output error'), stream]) as opened, \
                patch('verifier.comparator.queue.time.sleep') as sleep:
            self.assertEqual(healthy(self.queue)['catalog_sha256'], self.service.catalog_sha)
        self.assertEqual(opened.call_count, 3)
        self.assertEqual(sleep.call_count, 2)
        with patch.object(Path, 'open', side_effect=OSError(errno.EIO, 'Input/output error')) as opened, \
                patch('verifier.comparator.queue.time.sleep') as sleep:
            with self.assertRaises(ComparatorInfrastructureError):healthy(self.queue)
        opened.assert_called_once()
        sleep.assert_not_called()

    async def test_eio_during_close_does_not_mask_retryable_stale_read(self):
        class BrokenStream:
            def __enter__(self): return self
            def read(self, size): raise OSError(errno.ESTALE, 'Stale file handle')
            def __exit__(self, kind, value, trace): raise OSError(errno.EIO, 'Input/output error')
        path = self.queue / 'service.json'
        with path.open('rb') as stream, patch.object(Path, 'open', side_effect=[BrokenStream(), stream]) as opened, \
                patch('verifier.comparator.queue.time.sleep') as sleep:
            self.assertEqual(healthy(self.queue)['catalog_sha256'], self.service.catalog_sha)
        self.assertEqual(opened.call_count, 2)
        sleep.assert_called_once_with(0.05)

    async def test_persistent_estale_is_bounded_and_remains_infrastructure_error(self):
        with patch.object(Path, 'open', side_effect=OSError(errno.ESTALE, 'Stale file handle')) as opened, \
                patch('verifier.comparator.queue.time.sleep') as sleep:
            with self.assertRaises(ComparatorInfrastructureError) as caught:
                healthy(self.queue)
        self.assertEqual(opened.call_count, 6)
        self.assertEqual(sleep.call_count, 5)
        self.assertEqual(caught.exception.__cause__.errno, errno.ESTALE)
        self.assertEqual(list((self.queue / 'requests').iterdir()), [])

    async def test_other_io_errors_are_not_retried(self):
        with patch.object(Path, 'open', side_effect=OSError(errno.EACCES, 'Permission denied')) as opened, \
                patch('verifier.comparator.queue.time.sleep') as sleep:
            with self.assertRaises(ComparatorInfrastructureError):
                healthy(self.queue)
        opened.assert_called_once()
        sleep.assert_not_called()

    async def test_forged_result_identity_rejected(self):
        client,directory=await self.request()
        atomic_json(directory/'result.json', {'id':directory.name,'source_sha256':'wrong',
                    'status':'completed','verdict':{'accepted':True}})
        with self.assertRaises(ComparatorInfrastructureError): await client

if __name__ == '__main__': unittest.main()
