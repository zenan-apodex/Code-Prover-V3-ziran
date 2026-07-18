-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ListToFrequencyDict_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def ListToFrequencyDict (lst : List Int) (h_precond : ListToFrequencyDict_precond lst) :
    List (Int × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def ListToFrequencyDict_postcond (lst : List Int) (result : List (Int × Int))
    (h_precond : ListToFrequencyDict_precond lst) : Prop :=
  -- !benchmark @start postcond
  result.Pairwise (fun p q => p.1 ≠ q.1) ∧
  (∀ x : Int, (∃ n : Int, (x, n) ∈ result) ↔ x ∈ lst) ∧
  ∀ x n : Int, (x, n) ∈ result → n = Int.ofNat (lst.count x)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem ListToFrequencyDict_spec_satisfied (lst : List Int)
    (h_precond : ListToFrequencyDict_precond lst) :
    ListToFrequencyDict_postcond lst (ListToFrequencyDict lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof