-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def DistinctSortedElements_precond (input_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def DistinctSortedElements (input_list : List Int) (h_precond : DistinctSortedElements_precond input_list) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def DistinctSortedElements_postcond (input_list : List Int) (result : List Int)
    (h_precond : DistinctSortedElements_precond input_list) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun a b => a < b) result ∧
  ∀ x : Int, x ∈ result ↔ x ∈ input_list
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem DistinctSortedElements_spec_satisfied (input_list : List Int)
    (h_precond : DistinctSortedElements_precond input_list) :
    DistinctSortedElements_postcond input_list (DistinctSortedElements input_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof