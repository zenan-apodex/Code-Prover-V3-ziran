import Mathlib
import Std.Data.HashMap

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(impl: List Int → Int)
-- inputs
(arr: List Int) :=
-- spec
let spec (result: Int) :=
  ¬arr.any (fun x => 1 < arr.count x) →
  (arr.length = 0 ∨ arr.length = 1 → result = -1) ∧
  (1 < arr.length →
    let last := arr.length-1;
    let i := if arr[last]! < arr[last-1]! then Int.ofNat last else -1;
    result = max (impl (arr.take last)) i);
-- program termination
∃ result, impl arr = result ∧
-- return value satisfies spec
spec result
-- end_def problem_spec
-- === END: SPEC ===

-- === BEGIN: IMPLEMENTATION (fill in) ===
-- start_def implementation_signature
def implementation (arr: List Int) : Int :=
-- end_def implementation_signature
-- !benchmark @start code
  sorry
-- !benchmark @end code
-- === END: IMPLEMENTATION ===

-- === BEGIN: CORRECTNESS (prove) ===
-- start_def correctness_definition
theorem correctness
(arr: List Int)
: problem_spec implementation arr :=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
