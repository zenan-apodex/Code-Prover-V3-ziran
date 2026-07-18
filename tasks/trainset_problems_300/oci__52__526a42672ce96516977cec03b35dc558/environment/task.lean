-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountUniqueElements_precond (arr : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def CountUniqueElements (arr : List Int) (h_precond : CountUniqueElements_precond arr) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def CountUniqueElements_postcond (arr : List Int) (result : Int)
    (h_precond : CountUniqueElements_precond arr) : Prop :=
  -- !benchmark @start postcond
  ∃ u : List Int,
    u.Nodup ∧
    (∀ x : Int, x ∈ u ↔ x ∈ arr) ∧
    result = Int.ofNat u.length
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem CountUniqueElements_spec_satisfied (arr : List Int)
    (h_precond : CountUniqueElements_precond arr) :
    CountUniqueElements_postcond arr (CountUniqueElements arr h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof