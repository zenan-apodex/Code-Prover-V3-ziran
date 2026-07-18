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
let spec (result: Int) :=
  let dig_sum (x: Int): Int :=
    let digs := Nat.digits 10 x.natAbs;
    if x >= 0 then
      (List.map (fun t => (t: Int)) digs).sum
    else
      (List.map (fun t => (t: Int)) (digs.drop 1)).sum - (digs[0]! : Int);
  (arr = [] → result = 0) ∧
  (arr ≠ [] → 0 < (dig_sum arr[0]!) → result = 1 + implementation (arr.drop 1)) ∧
  (arr ≠ [] → (dig_sum arr[0]!) ≤ 0 → result = implementation (arr.drop 1));
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
