-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def PairElements_precond (list1 : List Int) (list2 : List String) : Prop :=
  -- !benchmark @start precond
  list1.length = list2.length
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def PairElements (list1 : List Int) (list2 : List String)
    (h_precond : PairElements_precond list1 list2) : List (Int × String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def PairElements_postcond (list1 : List Int) (list2 : List String)
    (result : List (Int × String)) (h_precond : PairElements_precond list1 list2) : Prop :=
  -- !benchmark @start postcond
  result.length = list1.length ∧
  result.length = list2.length ∧
  (∀ i : Nat, i < result.length → result[i]! = (list1[i]!, list2[i]!))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem PairElements_spec_satisfied (list1 : List Int) (list2 : List String)
    (h_precond : PairElements_precond list1 list2) :
    PairElements_postcond list1 list2 (PairElements list1 list2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof