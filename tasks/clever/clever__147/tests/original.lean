import Mathlib
import Std.Data.HashMap

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(impl: Nat → Nat)
-- inputs
(n: Nat) :=
-- spec
let spec (result: Nat) :=
∃ (S : Finset (Nat × Nat × Nat)), S.card = result ∧
  ∀ (triple: Nat × Nat × Nat),
    let (i, j, k) := triple;
    let a_i := i * i - i + 1;
    let a_j := j * j - j + 1;
    let a_k := k * k - k + 1;
    (1 ≤ i ∧ i < j ∧ j < k ∧ k ≤ n ∧
    (a_i + a_j + a_k) % 3 = 0)
    ↔ triple ∈ S
-- program termination
∃ result, impl n = result ∧
-- return value satisfies spec
spec result
-- end_def problem_spec
-- === END: SPEC ===

-- === BEGIN: IMPLEMENTATION (fill in) ===
-- start_def implementation_signature
def implementation (n: Nat) : Nat :=
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
