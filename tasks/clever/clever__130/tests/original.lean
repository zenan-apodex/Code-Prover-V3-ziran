import Mathlib
import Std.Data.HashMap

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(impl: Nat → List Int)
-- inputs
(n: Nat) :=
-- spec
let spec (result: List Int) :=
  0 < result.length ∧
  result.length = n ∧
  let i := result.length-1;
  (i = 0 → result[0]! = 1) ∧ -- base case
  (i = 1 → result[1]! = 3) ∧
  (2 ≤ i ∧ i % 2 = 0 → result[i]! = 1 + i / 2) ∧
  (2 ≤ i ∧ i % 2 = 1 → result[i]! = result[i-2]! + result[i-1]! + (1 + (i+1) / 2)) ∧
  if i = 0 then true else result.take i = impl (i-1)
-- program termination
∃ result, impl n = result ∧
-- return value satisfies spec
spec result
-- end_def problem_spec
-- === END: SPEC ===

-- === BEGIN: IMPLEMENTATION (fill in) ===
-- start_def implementation_signature
def implementation (n: Nat) : List Int:=
-- end_def implementation_signature
-- !benchmark @start code
  sorry
-- !benchmark @end code
-- === END: IMPLEMENTATION ===

-- === BEGIN: CORRECTNESS (prove) ===
-- start_def correctness_definition
theorem correctness
(n: Nat)
: problem_spec implementation n :=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
