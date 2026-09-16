"""One-off: kill orphaned JB sandboxes leaked by the 2026-07-23 13:00 host
restart (v1-round1 launch died mid-create, 119 zenan-no-internet sandboxes
left running). Usage:
    source .env && PYTHONPATH=$PWD .venv-aliyun/bin/python tools/kill_jb_orphans.py
"""
from tools.aliyun_clusters import configure_env

configure_env("jb")

from e2b import Sandbox


def list_all() -> list:
    pag = Sandbox.list()
    items = []
    while pag.has_next:
        items.extend(pag.next_items())
    return items


items = list_all()
print(f"killing {len(items)} sandboxes...")
ok = fail = 0
for s in items:
    try:
        Sandbox.kill(s.sandbox_id)
        ok += 1
    except Exception as e:
        fail += 1
        print(f"  FAIL {s.sandbox_id}: {e}")
print(f"killed: {ok}, failed: {fail}")
print(f"remaining live: {len(list_all())}")
