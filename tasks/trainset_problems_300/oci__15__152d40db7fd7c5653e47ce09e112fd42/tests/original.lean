-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def GenerateFibonacci_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 50
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def GenerateFibonacci (n : Int) (h_precond : GenerateFibonacci_precond n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsFibonacciPrefix (xs : List Int) : Prop :=
  (0 < xs.length → xs[0]! = 0) ∧
  (1 < xs.length → xs[1]! = 1) ∧
  (∀ i : Nat, i + 2 < xs.length → xs[i + 2]! = xs[i + 1]! + xs[i]!)
-- !benchmark @end postcond_aux


@[reducible, simp]
def GenerateFibonacci_postcond (n : Int) (result : List Int)
    (h_precond : GenerateFibonacci_precond n) : Prop :=
  -- !benchmark @start postcond
  result.length = Int.toNat n ∧ IsFibonacciPrefix result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem GenerateFibonacci_spec_satisfied (n : Int) (h_precond : GenerateFibonacci_precond n) :
    GenerateFibonacci_postcond n (GenerateFibonacci n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof