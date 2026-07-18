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
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def WordBreak (s : String) (wordDict : List String) (h_precond : WordBreak_precond s wordDict) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `canSegment cs words` holds iff the list of characters `cs` can be written as
    a concatenation of words (each word's `.toList`) drawn from `words`. -/
def canSegment (cs : List Char) (words : List String) : Prop :=
  ∃ (parts : List String),
    parts.flatMap String.toList = cs ∧
    ∀ w ∈ parts, w ∈ words
-- !benchmark @end postcond_aux


@[reducible, simp]
def WordBreak_postcond (s : String) (wordDict : List String) (result : Bool) (h_precond : WordBreak_precond s wordDict) : Prop :=
  -- !benchmark @start postcond
  result = true ↔ canSegment s.toList wordDict
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem WordBreak_spec_satisfied (s : String) (wordDict : List String) (h_precond : WordBreak_precond s wordDict) :
    WordBreak_postcond s wordDict (WordBreak s wordDict h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof