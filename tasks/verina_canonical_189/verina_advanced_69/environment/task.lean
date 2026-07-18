-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def searchInsert_precond (xs : List Int) (target : Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (· < ·) xs
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def searchInsert (xs : List Int) (target : Int) (h_precond : searchInsert_precond (xs) (target)) : Nat :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def searchInsert_postcond (xs : List Int) (target : Int) (result: Nat) (h_precond : searchInsert_precond (xs) (target)) : Prop :=
  -- !benchmark @start postcond
  let allBeforeLess := (List.range result).all (fun i => xs[i]! < target)
  let inBounds := result ≤ xs.length
  let insertedCorrectly :=
    result < xs.length → target ≤ xs[result]!
  inBounds ∧ allBeforeLess ∧ insertedCorrectly
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem searchInsert_spec_satisfied (xs: List Int) (target: Int) (h_precond : searchInsert_precond (xs) (target)) :
    searchInsert_postcond (xs) (target) (searchInsert (xs) (target) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


