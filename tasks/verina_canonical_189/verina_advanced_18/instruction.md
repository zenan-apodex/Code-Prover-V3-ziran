Solve the Lean 4 verification task at `/task/verina_advanced_18.lean`.

The file is a specification with `sorry` placeholders: a function definition
(the *code* sorry) and/or a correctness theorem (the *proof* sorry). Your job
is to replace every `sorry` so that the file compiles cleanly.

## THE ONE RULE

**Never modify the specification. Never.** Preconditions, postconditions,
function signatures, theorem statements, imports, and every `-- !benchmark`
marker line are read-only and verified byte-for-byte after you finish. In
particular:

- NEVER rewrite the whole file — make surgical edits inside the editable
  regions only (use `Edit` or `lean_replace_sorry`, never `Write`);
- put ALL helper definitions and lemmas INSIDE a `*_aux` region — a helper
  placed outside the markers fails the task even if the proof is correct;
- do not reformat, re-indent, or "clean up" any read-only line — even a
  single added or removed space fails the byte-for-byte check;
- do not insert `set_option`, `instance`, `open`, or attributes outside
  the editable regions;
- if your code needs a definition that only appears LATER in the file (e.g.
  a postcond helper defined below your editable region), do NOT move it up —
  duplicate the logic under a NEW name inside your editable region;
- if a read-only function is awkward to prove about (few Mathlib lemmas),
  do NOT swap it for an "equivalent" one (e.g. `eraseDups` -> `dedup`) —
  prove a bridging lemma in a `*_aux` region instead.

## Self-check protocol (mandatory)

As your VERY FIRST action run `cp /task/verina_advanced_18.lean /tmp/task-orig.lean`. Before
you consider the task done, run `diff /tmp/task-orig.lean /task/verina_advanced_18.lean` and
verify that EVERY changed hunk lies strictly between a
`-- !benchmark @start` and `-- !benchmark @end` line of an editable region
(`code`, `proof`, `solution_aux`, `code_aux`, `proof_aux`). If any hunk
touches a line outside those regions, restore that line byte-for-byte from
`/tmp/task-orig.lean` and redo the change legally. A perfect proof with one
stray edit outside the editable regions scores ZERO.

## Success criteria (graded automatically after you finish)

1. `lake env lean /task/verina_advanced_18.lean` (run from `/task`) reports zero errors;
2. no `sorry` remains anywhere in the file;
3. every theorem depends only on the standard axioms
   (`propext`, `Classical.choice`, `Quot.sound`) — check with
   `#print axioms <theoremName>`;
4. the specification is untouched: you may ONLY edit the contents of the
   `-- !benchmark @start/@end` regions named `code`, `proof`, `solution_aux`,
   `code_aux`, and `proof_aux`. Everything else — imports, marker lines,
   preconditions, postconditions, signatures, theorem statements — is
   compared byte-for-byte against the original and any change fails the task;
5. no forbidden construct anywhere in the file: `axiom`, `constant`,
   `opaque`, `unsafe` declarations and the negation workflow
   (`negation` / `negate_goal` / `Tacs.Negate`) all fail the task.

## Rules and hints

- If the statement seems false, try harder to prove it — disproving is not
  an option (see criterion 5).
- Prefer simple, structurally recursive implementations using List/Array
  operations with known Mathlib lemmas over clever imperative code —
  you must also prove the postcondition about it.
- Mathlib (~100K theorems) is preloaded; search it before hand-rolling
  proofs. Decompose hard goals into `private lemma`s inside the `*_aux`
  regions.
- The `lean-lsp` MCP tools (e.g. `lean_diagnostic_messages`, `lean_goal`,
  `lean_multi_attempt`) give fast feedback without full recompiles; use them
  after every edit. `lake env lean /task/verina_advanced_18.lean` is the ground truth.

You are running unattended: never stop to ask for confirmation, and keep iterating until every criterion is met or your session is terminated.
