import Mathlib
import Std.Data.HashMap

-- === BEGIN: shared helper definitions (provided) ===
/--
name: fibonacci_non_computable_3
use: |
  Non-computable definition to check if a number is a Fibonacci number such that
  fib(n) = fib(n - 1) + fib(n - 2) + fib(n - 3).
problems:
  - 63
-/
inductive fibonacci_non_computable_3 : ℕ → ℕ → Prop
| base0 : fibonacci_non_computable_3 0 0
| base1 : fibonacci_non_computable_3 1 0
| base2 : fibonacci_non_computable_3 2 1
| step : ∀ n f₁ f₂ f₃, fibonacci_non_computable_3 n f₁ →
fibonacci_non_computable_3 (n + 1) f₂ →
fibonacci_non_computable_3 (n + 2) f₃ →
fibonacci_non_computable_3 (n + 3) (f₁ + f₂ + f₃)
-- === END: shared helper definitions ===

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(implementation: Nat → Nat)
-- inputs
(n: Nat) :=
-- spec
let spec (result: Nat) :=
fibonacci_non_computable_3 n result
-- program termination
∃ result, implementation n = result ∧
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
: problem_spec implementation n
:=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
