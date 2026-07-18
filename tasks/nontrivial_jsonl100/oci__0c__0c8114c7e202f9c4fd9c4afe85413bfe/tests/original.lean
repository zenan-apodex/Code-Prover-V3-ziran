-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def GenerateSubsets_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ n ∧ n ≤ 15
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def GenerateSubsets (n : Int) (h_precond : GenerateSubsets_precond n) : List (List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list `s` is a valid subset of {1, ..., n} if all elements are in [1, n] and there are no duplicates. -/
def isSubsetOf1ToN (s : List Int) (n : Int) : Prop :=
  (∀ x ∈ s, 1 ≤ x ∧ x ≤ n) ∧ s.Nodup

/-- Two lists represent the same set -/
def sameIntSet (a b : List Int) : Prop :=
  ∀ x : Int, x ∈ a ↔ x ∈ b
-- !benchmark @end postcond_aux


@[reducible, simp]
def GenerateSubsets_postcond (n : Int) (result : List (List Int)) (h_precond : GenerateSubsets_precond n) : Prop :=
  -- !benchmark @start postcond
  -- 1. Every list in result is a valid subset of {1, ..., n}
  (∀ s ∈ result, isSubsetOf1ToN s n) ∧
  -- 2. Every valid subset of {1, ..., n} is represented in result (up to set equality)
  (∀ s : List Int, isSubsetOf1ToN s n →
    ∃ t ∈ result, sameIntSet s t) ∧
  -- 3. No two distinct entries in result represent the same set (uniqueness)
  (∀ i j : Nat, i < result.length → j < result.length →
    sameIntSet (result[i]!) (result[j]!) → i = j)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem GenerateSubsets_spec_satisfied (n : Int) (h_precond : GenerateSubsets_precond n) :
    GenerateSubsets_postcond n (GenerateSubsets n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof