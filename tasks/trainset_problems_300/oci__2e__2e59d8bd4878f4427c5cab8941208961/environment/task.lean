-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountPerfectSquares_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CountPerfectSquares (nums : List Int) (h_precond : CountPerfectSquares_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsPerfectSquare (n : Int) : Prop :=
  ∃ k : Int, k * k = n
-- !benchmark @end postcond_aux


@[reducible, simp]
def CountPerfectSquares_postcond (nums : List Int) (result : Int)
    (h_precond : CountPerfectSquares_precond nums) : Prop :=
  -- !benchmark @start postcond
  ∃ idxs : List Nat,
    idxs.Nodup ∧
    result = Int.ofNat idxs.length ∧
    (∀ i : Nat, i ∈ idxs → i < nums.length) ∧
    (∀ i : Nat, i < nums.length → (i ∈ idxs ↔ IsPerfectSquare (nums[i]!)))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CountPerfectSquares_spec_satisfied (nums : List Int)
    (h_precond : CountPerfectSquares_precond nums) :
    CountPerfectSquares_postcond nums (CountPerfectSquares nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof