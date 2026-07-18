-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def Gcd_precond (a : Int) (b : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ a ∧ 0 ≤ b
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def Gcd (a : Int) (b : Int) (h_precond : Gcd_precond a b) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def Gcd_postcond (a : Int) (b : Int) (result : Int) (h_precond : Gcd_precond a b) : Prop :=
  -- !benchmark @start postcond
  if a = 0 ∧ b = 0 then
    result = 0
  else
    result > 0 ∧
    result ∣ a ∧
    result ∣ b ∧
    ∀ d : Int, d > 0 → d ∣ a → d ∣ b → d ≤ result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem Gcd_spec_satisfied (a : Int) (b : Int) (h_precond : Gcd_precond a b) :
    Gcd_postcond a b (Gcd a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof