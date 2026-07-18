-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortProductsByPrice_precond (products : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a.1 ≠ b.1) products
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SortProductsByPrice (products : List (String × Int))
    (h_precond : SortProductsByPrice_precond products) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def SortProductsByPrice_postcond (products : List (String × Int))
    (result : List (String × Int))
    (h_precond : SortProductsByPrice_precond products) : Prop :=
  -- !benchmark @start postcond
  result.Perm products ∧
  List.Pairwise (fun a b => a.2 ≤ b.2) result ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SortProductsByPrice_spec_satisfied (products : List (String × Int))
    (h_precond : SortProductsByPrice_precond products) :
    SortProductsByPrice_postcond products (SortProductsByPrice products h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof