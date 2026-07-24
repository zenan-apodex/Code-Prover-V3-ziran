# VeriSoftBench Harbor adapter

This directory deliberately does **not** vendor the upstream benchmark release
or its roughly 110 GB multi-repository Lean environment.  The committed V3
contract is:

- `migration/v2/verisoftbench-500.json`: all 500 ordered task identities,
  record hashes, upstream revision, and hashes of the native evaluator files;
- `migration/v2/verisoftbench-repos.json`: the 23 repository/toolchain pins;
- `tools/migrate_verisoft_campaign.py`: fail-closed replay and Harbor task
  materialization;
- `verisoft/harbor_grade.py`: a Harbor verifier which calls the frozen native
  `LeanREPL`/utility implementation rather than V3's single-file Lean grader.

The generated tasks use the upstream `filtered_context` prompt builder.  Their
acceptance result is the native `evaluate.py` compile-check path with fixing
disabled, matching `formal-benchmark-campaign-v1`.

## External boundary

Replaying the campaign requires a checkout of VeriSoftBench at
`0c3d7931433bfa5dfa5c04259e6660cf62f178c8` and a native image built from its
23 pinned repositories.  Generate both build context and tasks with:

```bash
python3 tools/migrate_verisoft_campaign.py image-context \
  --source-release /path/to/VeriSoftBench --out /path/to/image-context
docker build -t verisoftbench/harbor-native:0c3d7931433b /path/to/image-context

python3 tools/migrate_verisoft_campaign.py materialize \
  --source-release /path/to/VeriSoftBench \
  --image verisoftbench/harbor-native:0c3d7931433b
```

`materialize` defaults to the ignored
`tasks/_campaign_views/verisoftbench-500` runtime view.  Use `--limit 1` for a
small structural smoke.  The grader refuses an image which lacks the exact
per-repository revision sentinel emitted by `image-context`.
