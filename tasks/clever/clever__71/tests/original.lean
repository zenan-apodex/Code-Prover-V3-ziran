import Mathlib
import Std.Data.HashMap

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(implementation: Rat → Rat → Rat → Rat)
-- inputs
(a: Rat) (b: Rat) (c: Rat) :=
-- spec
let spec (result : Rat) :=
  let is_valid_triangle :=
    (a + b > c) ∧  (a + c > b) ∧ (b + c > a);
  let s :=
    (a + b + c) / 2;
  if is_valid_triangle then
    |result^2 - (s * (s-a) * (s-b) * (s-c))| ≤ ((1: Rat)/10000)
  else
    result = -1
-- program termination
∃ result, implementation a b c = result ∧
spec result
-- end_def problem_spec
-- === END: SPEC ===

-- === BEGIN: IMPLEMENTATION (fill in) ===
-- start_def implementation_signature
def implementation (a: Rat) (b: Rat) (c: Rat): Rat :=
-- end_def implementation_signature
-- !benchmark @start code
  sorry
-- !benchmark @end code
-- === END: IMPLEMENTATION ===

-- === BEGIN: CORRECTNESS (prove) ===
-- start_def correctness_definition
theorem correctness
(a: Rat) (b: Rat) (c: Rat)
: problem_spec implementation a b c
:=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
