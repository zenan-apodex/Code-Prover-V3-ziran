import Mathlib
import Std.Data.HashMap

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(implementation: List Int → Int)
-- inputs
(arr: List Int) :=
-- spec
let spec (result : Int) :=
  let changes_needed (arr1: List Int) (arr2: List Int) :=
    ((List.finRange (arr1.length)).filter (fun idx => arr1[idx]? ≠ arr2[idx]?)).length
  (∃ palin : List Int,
    palin.length = arr.length ∧
    List.Palindrome palin ∧
    result = changes_needed arr palin) ∧
  (∀ palin : List Int,
    palin.length = arr.length →
    List.Palindrome palin →
    result ≤ changes_needed arr palin)
-- program termination
∃ result, implementation arr = result ∧
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
: problem_spec implementation arr
:=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
