-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def UniqueSubstrings_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def UniqueSubstrings (s : String) (h_precond : UniqueSubstrings_precond s) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A string `t` is a non-empty substring of `s` iff there exist indices i < j
    such that t equals s[i..j]. We work on the underlying char lists. -/
def isNonEmptySubstring (t : String) (s : String) : Prop :=
  let cs := s.toList
  ∃ i j, i < j ∧ j ≤ cs.length ∧ t.toList = (cs.drop i).take (j - i)
-- !benchmark @end postcond_aux


@[reducible, simp]
def UniqueSubstrings_postcond (s : String) (result : List String) (h_precond : UniqueSubstrings_precond s) : Prop :=
  -- !benchmark @start postcond
  -- Every element in result is a non-empty substring of s
  (∀ t ∈ result, isNonEmptySubstring t s) ∧
  -- Every non-empty substring of s appears in result
  (∀ t, isNonEmptySubstring t s → t ∈ result) ∧
  -- No duplicates
  result.Nodup ∧
  -- Sorted in lexicographic order
  List.Pairwise (fun a b => a.toList < b.toList) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem UniqueSubstrings_spec_satisfied (s : String) (h_precond : UniqueSubstrings_precond s) :
    UniqueSubstrings_postcond s (UniqueSubstrings s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof