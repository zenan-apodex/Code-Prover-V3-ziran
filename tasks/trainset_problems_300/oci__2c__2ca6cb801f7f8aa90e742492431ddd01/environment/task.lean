-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def ValidTime (t : Int × Int) : Prop :=
  0 ≤ t.1 ∧ t.1 ≤ 23 ∧ 0 ≤ t.2 ∧ t.2 ≤ 59
-- !benchmark @end precond_aux

@[reducible, simp]
def SortTimes_precond (time_list : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  ∀ t ∈ time_list, ValidTime t
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SortTimes (time_list : List (Int × Int)) (h_precond : SortTimes_precond time_list) : List (Int × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def TimeLE (a b : Int × Int) : Prop :=
  a.1 < b.1 ∨ (a.1 = b.1 ∧ a.2 ≤ b.2)
-- !benchmark @end postcond_aux


@[reducible, simp]
def SortTimes_postcond (time_list : List (Int × Int)) (result : List (Int × Int))
    (h_precond : SortTimes_precond time_list) : Prop :=
  -- !benchmark @start postcond
  result.Perm time_list ∧ List.Pairwise TimeLE result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SortTimes_spec_satisfied (time_list : List (Int × Int)) (h_precond : SortTimes_precond time_list) :
    SortTimes_postcond time_list (SortTimes time_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof