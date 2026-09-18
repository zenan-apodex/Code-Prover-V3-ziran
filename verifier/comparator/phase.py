"""Trusted image entrypoint. Candidate compilation runs only in a disposable container."""
import ctypes
import os
import json
import pathlib
import shutil
import subprocess
import sys

BIN = pathlib.Path('/opt/codeprover/bin')
work = pathlib.Path('/work')

def run(args):
    return subprocess.run(args, cwd=work).returncode

def main():
    # DSW rejects the entire Docker --security-opt flag family. Set the same
    # restrictive no_new_privs bit before any Lean/native candidate code runs;
    # it is inherited by all children and cannot be cleared. DSW also disallows
    # --cap-drop. The non-root process has no effective/permitted/inheritable/
    # ambient capabilities; no_new_privs prevents gaining any on exec.
    if os.geteuid() == 0:
        raise RuntimeError('judge phases must not run as root')
    libc = ctypes.CDLL(None, use_errno=True)
    if libc.prctl(38, 1, 0, 0, 0) != 0:  # PR_SET_NO_NEW_PRIVS
        raise OSError(ctypes.get_errno(), 'PR_SET_NO_NEW_PRIVS failed')
    status = dict(line.split(':', 1) for line in pathlib.Path('/proc/self/status').read_text().splitlines() if ':' in line)
    if any(int(status[key].strip(), 16) for key in ('CapEff', 'CapPrm', 'CapInh', 'CapAmb')) or status['NoNewPrivs'].strip() != '1':
        raise RuntimeError('judge requires zero capabilities and no_new_privs')
    phase = sys.argv[1]
    if phase == 'compare':
        return run([str(BIN / 'codeprover_comparator'), '/input/targets.json',
                    '/input/challenge.ndjson', '/input/solution.ndjson'])
    if phase not in ('challenge', 'solution'):
        raise ValueError('unknown phase')
    if pathlib.Path('/task/lean-toolchain').read_text().strip() != 'leanprover/lean4:v4.28.0':
        raise RuntimeError('image must use Lean/Mathlib 4.28')
    # Use only the baked, read-only oleans. Calling `lake build` would let Lake
    # try to reconcile dependency git URLs and mutate the shared package tree.
    packages = sorted(pathlib.Path('/task/.lake/packages').glob('*/.lake/build/lib/lean'))
    if not any((p / 'Mathlib.olean').is_file() for p in packages):
        raise RuntimeError('trusted Mathlib cache missing')
    os.environ['LEAN_PATH'] = ':'.join([str(work), *(str(p) for p in packages)])
    shutil.copyfile('/input/Main.lean', work / 'Main.lean')
    compile_code = run(['lean', '-o', '/work/Main.olean', '/work/Main.lean'])
    if compile_code:
        return 10 if compile_code == 1 else 20  # candidate compile rejection; challenge maps this to infra
    if phase == 'challenge':
        with (work / 'targets.json').open('w') as out:
            subprocess.run([str(BIN / 'codeprover_targets')], cwd=work,
                           stdout=out, check=True)
    else:
        shutil.copyfile('/input/targets.json', work / 'targets.json')
    config = json.loads((work / 'targets.json').read_text())
    primitives = json.loads(subprocess.check_output([str(BIN / 'codeprover_comparator'), '--primitives']))
    names = list(dict.fromkeys(config['theorem_names'] + config['definition_names'] + primitives))
    with (work / 'export.ndjson').open('w') as out:
        proc = subprocess.run([str(BIN / 'lean4export'), 'Main', '--', *names],
                              cwd=work, stdout=out)
    return 0 if proc.returncode == 0 else (11 if proc.returncode == 1 else 20)

if __name__ == '__main__':
    try:
        result = main()
    except Exception:
        import traceback
        traceback.print_exc()
        result = 20  # image/setup failures must never look like a proof rejection
    sys.exit(result)
