import Mathlib
import Std.Data.HashMap

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(implementation: List Int → Bool)
-- inputs
(arr: List Int) :=
let is_shifted (xs: List Int) (ys: List Int) (i: Nat) :=
  (xs.length = ys.length) ∧
  (0 <= i) ∧
  (i < xs.length) ∧
  (forall j, (0 <= j ∧ j < ys.length) → (ys[j]! = xs[(j-i) % xs.length]!))
-- spec
let spec (result: Bool) :=
  ((arr = []) → (result = True)) ∧
  result ↔ (exists i, exists arr_shifted, (is_shifted arr arr_shifted i) ∧ (List.Sorted Int.le arr_shifted))
-- program termination
∃ result, implementation arr = result ∧
spec result
-- end_def problem_spec
-- === END: SPEC ===

-- === BEGIN: IMPLEMENTATION (fill in) ===
-- start_def implementation_signature
def implementation (arr: List Int) : Bool :=
-- end_def implementation_signature
-- !benchmark @start code
  sorry
-- !benchmark @end code
-- === END: IMPLEMENTATION ===

-- === BEGIN: CORRECTNESS (prove) ===
-- start_def correctness_definition
theorem correctness
(arr: List Int)
: problem_spec implementation arr
:=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
