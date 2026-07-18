Solve the Lean 4 verification task at `/task/fvapps__4666.lean`.

The file is a specification with `sorry` placeholders: a function definition
(the *code* sorry) and/or a correctness theorem (the *proof* sorry). Your job
is to replace every `sorry` so that the file compiles cleanly.

## Success criteria (graded automatically after you finish)

1. `lake env lean /task/fvapps__4666.lean` (run from `/task`) reports zero errors;
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
  after every edit. `lake env lean /task/fvapps__4666.lean` is the ground truth.

You are running unattended: never stop to ask for confirmation, and keep iterating until every criterion is met or your session is terminated.
