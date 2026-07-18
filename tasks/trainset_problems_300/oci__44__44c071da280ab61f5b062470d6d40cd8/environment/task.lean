-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindDuplicates_precond (input_list : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindDuplicates (input_list : List Int) (h_precond : FindDuplicates_precond input_list) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def IsDuplicateIn (input_list : List Int) (x : Int) : Prop :=
  2 ≤ input_list.count x
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindDuplicates_postcond (input_list : List Int) (result : List Int)
    (h_precond : FindDuplicates_precond input_list) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧ ∀ x : Int, x ∈ result ↔ IsDuplicateIn input_list x
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindDuplicates_spec_satisfied (input_list : List Int)
    (h_precond : FindDuplicates_precond input_list) :
    FindDuplicates_postcond input_list (FindDuplicates input_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof