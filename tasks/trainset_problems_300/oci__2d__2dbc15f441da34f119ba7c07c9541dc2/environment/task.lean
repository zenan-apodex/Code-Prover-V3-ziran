-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def IsLowercaseEnglish (c : Char) : Prop :=
  'a' ≤ c ∧ c ≤ 'z'
-- !benchmark @end precond_aux

@[reducible, simp]
def LexicographicallySmallestString_precond (s : String) : Prop :=
  -- !benchmark @start precond
  ∀ c ∈ s.toList, IsLowercaseEnglish c
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def LexicographicallySmallestString (s : String)
    (h_precond : LexicographicallySmallestString_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def LexicographicallySmallestString_postcond (s : String) (result : String)
    (h_precond : LexicographicallySmallestString_precond s) : Prop :=
  -- !benchmark @start postcond
  result.toList.Perm s.toList ∧
  List.Pairwise (fun a b => a ≤ b) result.toList
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem LexicographicallySmallestString_spec_satisfied (s : String)
    (h_precond : LexicographicallySmallestString_precond s) :
    LexicographicallySmallestString_postcond s
      (LexicographicallySmallestString s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof