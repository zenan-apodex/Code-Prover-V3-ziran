-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountFrequencies_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def CountFrequencies (lst : List Int) (h_precond : CountFrequencies_precond lst) : List (Int × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def KeyUnique (result : List (Int × Int)) : Prop :=
  List.Pairwise (fun a b => a.1 ≠ b.1) result
-- !benchmark @end postcond_aux

@[reducible, simp]
def CountFrequencies_postcond (lst : List Int) (result : List (Int × Int))
    (h_precond : CountFrequencies_precond lst) : Prop :=
  -- !benchmark @start postcond
  KeyUnique result ∧
  (∀ p ∈ result, p.2 = Int.ofNat (lst.count p.1) ∧ 0 < p.2) ∧
  (∀ x : Int, x ∈ lst ↔ ∃ c : Int, (x, c) ∈ result)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem CountFrequencies_spec_satisfied (lst : List Int)
    (h_precond : CountFrequencies_precond lst) :
    CountFrequencies_postcond lst (CountFrequencies lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof