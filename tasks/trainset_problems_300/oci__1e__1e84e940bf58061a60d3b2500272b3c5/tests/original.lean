-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindNthXorFibonacci_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 1000000000000000000
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindNthXorFibonacci (n : Int) (h_precond : FindNthXorFibonacci_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindNthXorFibonacci_postcond (n : Int) (result : Int)
    (h_precond : FindNthXorFibonacci_precond n) : Prop :=
  -- !benchmark @start postcond
  (result = 0 ↔ n % 3 = 2) ∧
  (result = 1 ↔ n % 3 = 0 ∨ n % 3 = 1)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindNthXorFibonacci_spec_satisfied (n : Int)
    (h_precond : FindNthXorFibonacci_precond n) :
    FindNthXorFibonacci_postcond n (FindNthXorFibonacci n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof