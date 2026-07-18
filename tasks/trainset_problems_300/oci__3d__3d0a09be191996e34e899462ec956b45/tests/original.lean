-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def IntIsPrime (n : Int) : Prop :=
  n ≥ 2 ∧ Nat.Prime n.natAbs
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPrime_precond (num : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def IsPrime (num : Int) (h_precond : IsPrime_precond num) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def IsPrime_postcond (num : Int) (result : Bool)
    (h_precond : IsPrime_precond num) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ IntIsPrime num) ∧
  (result = false ↔ ¬ IntIsPrime num)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem IsPrime_spec_satisfied (num : Int)
    (h_precond : IsPrime_precond num) :
    IsPrime_postcond num (IsPrime num h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof