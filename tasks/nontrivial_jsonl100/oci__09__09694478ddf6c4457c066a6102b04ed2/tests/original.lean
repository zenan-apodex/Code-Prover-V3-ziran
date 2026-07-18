-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def WordBreak_precond (s : String) (wordDict : List String) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (· ≠ ·) wordDict
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def WordBreak (s : String) (wordDict : List String) (h_precond : WordBreak_precond s wordDict) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A string can be segmented into a sequence of words from the dictionary.
    `canSegment s wordDict` means there exists a list of words, each in wordDict,
    whose concatenation equals s. -/
def canSegment (s : String) (wordDict : List String) : Prop :=
  ∃ (words : List String), (∀ w ∈ words, w ∈ wordDict) ∧ String.join words = s
-- !benchmark @end postcond_aux


@[reducible, simp]
def WordBreak_postcond (s : String) (wordDict : List String) (result : Bool) (h_precond : WordBreak_precond s wordDict) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ canSegment s wordDict
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem WordBreak_spec_satisfied (s : String) (wordDict : List String) (h_precond : WordBreak_precond s wordDict) :
    WordBreak_postcond s wordDict (WordBreak s wordDict h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof