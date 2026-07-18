-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def NLargestIntegers_precond (lst : List Int) (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def NLargestIntegers (lst : List Int) (n : Int) (h_precond : NLargestIntegers_precond lst n) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def NLargestIntegers_postcond (lst : List Int) (n : Int) (result : List Int)
    (h_precond : NLargestIntegers_precond lst n) : Prop :=
  -- !benchmark @start postcond
  result.length = min lst.length n.toNat ∧
  List.Pairwise (fun a b => a ≥ b) result ∧
  ∃ rest : List Int,
    (result ++ rest).Perm lst ∧
    ∀ x, x ∈ result → ∀ y, y ∈ rest → x ≥ y
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem NLargestIntegers_spec_satisfied (lst : List Int) (n : Int)
    (h_precond : NLargestIntegers_precond lst n) :
    NLargestIntegers_postcond lst n (NLargestIntegers lst n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof