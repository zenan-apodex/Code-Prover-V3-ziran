-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortKeysByValuesDescending_precond (d : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a.1 ≠ b.1) d
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SortKeysByValuesDescending (d : List (String × Int))
    (h_precond : SortKeysByValuesDescending_precond d) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def KeyHasValue (d : List (String × Int)) (k : String) (v : Int) : Prop :=
  (k, v) ∈ d
-- !benchmark @end postcond_aux


@[reducible, simp]
def SortKeysByValuesDescending_postcond (d : List (String × Int)) (result : List String)
    (h_precond : SortKeysByValuesDescending_precond d) : Prop :=
  -- !benchmark @start postcond
  result.Perm (d.map Prod.fst) ∧
  (∀ i j : Nat,
    i < j →
    j < result.length →
    ∃ vi vj : Int,
      KeyHasValue d (result[i]!) vi ∧
      KeyHasValue d (result[j]!) vj ∧
      vi ≥ vj)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SortKeysByValuesDescending_spec_satisfied (d : List (String × Int))
    (h_precond : SortKeysByValuesDescending_precond d) :
    SortKeysByValuesDescending_postcond d (SortKeysByValuesDescending d h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof