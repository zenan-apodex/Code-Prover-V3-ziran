import Mathlib
import Std.Data.HashMap

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(implementation: String → String → Nat)
-- inputs
(string substring: String) :=
-- spec
let spec (result: Nat) :=
(substring.length = 0 → result = string.length)
∧
(substring.length ≠ 0 →
(string.length < substring.length → result = 0)
∧
(string.length = substring.length →
((string = substring ↔ result = 1) ∧
(substring ≠ string ↔ result = 0)))
∧
(substring.length < string.length  →
let substring_start_idx := {i: Nat | i < string.length - substring.length + 1};
let substring_occurrences := {i ∈ substring_start_idx | (string.drop i).take substring.length = substring };
result = substring_occurrences.toFinset.card));
-- program termination
∃ result, implementation string substring = result ∧
spec result
-- end_def problem_spec
-- === END: SPEC ===

-- === BEGIN: IMPLEMENTATION (fill in) ===
-- start_def implementation_signature
def implementation (string: String) (substring: String) : Nat :=
-- end_def implementation_signature
-- !benchmark @start code
  sorry
-- !benchmark @end code
-- === END: IMPLEMENTATION ===

-- === BEGIN: CORRECTNESS (prove) ===
-- start_def correctness_definition
theorem correctness
(string: String)
(substring: String)
: problem_spec implementation string substring
:=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
