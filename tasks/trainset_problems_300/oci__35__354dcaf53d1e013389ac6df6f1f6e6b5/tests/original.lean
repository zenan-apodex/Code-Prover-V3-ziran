-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountOccurrences_precond (lst : List Int) (value : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def CountOccurrences (lst : List Int) (value : Int)
    (h_precond : CountOccurrences_precond lst value) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def CountOccurrences_postcond (lst : List Int) (value : Int) (result : Int)
    (h_precond : CountOccurrences_precond lst value) : Prop :=
  -- !benchmark @start postcond
  ∃ idxs : List Nat,
    idxs.Nodup ∧
    (∀ i, i ∈ idxs → i < lst.length ∧ lst[i]! = value) ∧
    (∀ i : Nat, i < lst.length → lst[i]! = value → i ∈ idxs) ∧
    result = (idxs.length : Int)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem CountOccurrences_spec_satisfied (lst : List Int) (value : Int)
    (h_precond : CountOccurrences_precond lst value) :
    CountOccurrences_postcond lst value (CountOccurrences lst value h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof