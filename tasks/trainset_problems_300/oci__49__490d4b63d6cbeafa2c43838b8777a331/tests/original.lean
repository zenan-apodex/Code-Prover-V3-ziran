-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortAndRemoveDuplicates_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SortAndRemoveDuplicates (numbers : List Int)
    (h_precond : SortAndRemoveDuplicates_precond numbers) : List Int × Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def SortAndRemoveDuplicates_postcond (numbers : List Int) (result : List Int × Int)
    (h_precond : SortAndRemoveDuplicates_precond numbers) : Prop :=
  -- !benchmark @start postcond
  let ys := result.1
  let n := result.2
  List.Pairwise (fun a b => a ≤ b) ys ∧
  ys.Nodup ∧
  (∀ x : Int, x ∈ ys ↔ x ∈ numbers) ∧
  n = (ys.length : Int)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SortAndRemoveDuplicates_spec_satisfied (numbers : List Int)
    (h_precond : SortAndRemoveDuplicates_precond numbers) :
    SortAndRemoveDuplicates_postcond numbers (SortAndRemoveDuplicates numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof