-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def GenerateCombinations_precond (numbers : List Int) (combination_length : Nat) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def GenerateCombinations (numbers : List Int) (combination_length : Nat) (h_precond : GenerateCombinations_precond numbers combination_length) : List (List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list `combo` is a valid combination of `numbers` of length `k` if there exists
    a strictly increasing sequence of indices into `numbers` of length `k` such that
    the elements at those indices form `combo`. -/
def isValidCombination (numbers : List Int) (k : Nat) (combo : List Int) : Prop :=
  ∃ (indices : List Nat),
    indices.length = k ∧
    combo.length = k ∧
    List.Pairwise (· < ·) indices ∧
    (∀ idx, idx ∈ indices → idx < numbers.length) ∧
    (∀ (p : Nat), p < k → combo[p]! = numbers[indices[p]!]!)
-- !benchmark @end postcond_aux


@[reducible, simp]
def GenerateCombinations_postcond (numbers : List Int) (combination_length : Nat) (result : List (List Int)) (h_precond : GenerateCombinations_precond numbers combination_length) : Prop :=
  -- !benchmark @start postcond
  -- Every element in result is a valid combination
  (∀ combo, combo ∈ result → isValidCombination numbers combination_length combo) ∧
  -- Every valid combination appears in result
  (∀ combo, isValidCombination numbers combination_length combo → combo ∈ result) ∧
  -- No duplicates in result
  result.Nodup
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem GenerateCombinations_spec_satisfied (numbers : List Int) (combination_length : Nat) (h_precond : GenerateCombinations_precond numbers combination_length) :
    GenerateCombinations_postcond numbers combination_length (GenerateCombinations numbers combination_length h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof