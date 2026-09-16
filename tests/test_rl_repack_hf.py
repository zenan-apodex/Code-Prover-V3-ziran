import json
from pathlib import Path
import tempfile
import unittest

import torch
from safetensors import safe_open
from safetensors.torch import save_file

from rl.repack_hf import reconstruct, repack


class RepackHFTests(unittest.TestCase):
    def test_export_uses_rl_weights_and_preserves_only_untrained_modules(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            original, converted, output = root/'original', root/'converted', root/'output'
            original.mkdir(); converted.mkdir()
            prefix = 'model.language_model.layers.0.mlp.experts'
            old = {prefix+'.gate_up_proj': torch.zeros(2,4,3,dtype=torch.bfloat16),
                   prefix+'.down_proj': torch.zeros(2,3,2,dtype=torch.bfloat16),
                   'model.language_model.norm.weight': torch.zeros(3,dtype=torch.bfloat16),
                   'model.visual.norm.weight': torch.full((3,),99,dtype=torch.bfloat16),
                   'mtp.layers.0.mlp.experts.gate_up_proj': torch.full((2,4,3),77,dtype=torch.bfloat16)}
            new = {'model.language_model.norm.weight': torch.ones(3,dtype=torch.bfloat16)}
            for i in range(2):
                for j,kind in enumerate(['gate','up','down']):
                    new[f'{prefix}.{i}.{kind}_proj.weight'] = torch.full(
                        (3,2) if kind=='down' else (2,3),i*10+j,dtype=torch.bfloat16)
            for path,tensors in [(original,old),(converted,new)]:
                save_file(tensors,path/'weights.safetensors')
                (path/'model.safetensors.index.json').write_text(json.dumps(
                    {'weight_map': {key:'weights.safetensors' for key in tensors}}))
            repack(converted,original,output)
            index=json.loads((output/'model.safetensors.index.json').read_text())['weight_map']
            self.assertEqual(set(index),set(old))
            with safe_open(output/next(iter(index.values())),framework='pt') as handle:
                value=handle.get_tensor(prefix+'.gate_up_proj')
                self.assertTrue(torch.all(value[0,:2]==0))
                self.assertTrue(torch.all(value[0,2:]==1))
                self.assertTrue(torch.all(value[1,:2]==10))
                self.assertTrue(torch.all(value[1,2:]==11))
                self.assertTrue(torch.all(handle.get_tensor(prefix+'.down_proj')[1]==12))
                self.assertTrue(torch.all(handle.get_tensor('model.language_model.norm.weight')==1))
                self.assertTrue(torch.all(handle.get_tensor('model.visual.norm.weight')==99))
                self.assertTrue(torch.all(handle.get_tensor('mtp.layers.0.mlp.experts.gate_up_proj')==77))

    def test_missing_language_model_weight_cannot_fall_back_to_sft(self):
        name='model.language_model.norm.weight'
        with self.assertRaisesRegex(ValueError,'missing trained'):
            reconstruct(name,torch.ones(1),{}, {name:lambda:torch.ones(1)},set())


if __name__=='__main__':
    unittest.main()
