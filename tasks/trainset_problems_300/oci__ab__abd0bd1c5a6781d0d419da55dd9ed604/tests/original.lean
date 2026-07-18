-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def LinearSearch_precond (lst : List Int) (target : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def LinearSearch (lst : List Int) (target : Int) (h_precond : LinearSearch_precond lst target) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def LinearSearch_postcond (lst : List Int) (target : Int) (result : Int)
    (h_precond : LinearSearch_precond lst target) : Prop :=
  -- !benchmark @start postcond
  (result = -1 ∧ ∀ i : Nat, i < lst.length → lst[i]! ≠ target) ∨
  (∃ n : Nat, result = Int.ofNat n ∧ n < lst.length ∧ lst[n]! = target ∧
    ∀ k : Nat, k < n → lst[k]! ≠ target)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem LinearSearch_spec_satisfied (lst : List Int) (target : Int)
    (h_precond : LinearSearch_precond lst target) :
    LinearSearch_postcond lst target (LinearSearch lst target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof