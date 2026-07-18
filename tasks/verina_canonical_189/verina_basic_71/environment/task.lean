-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible, simp]
def LongestCommonPrefix_precond (str1 : List Char) (str2 : List Char) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestCommonPrefix (str1 : List Char) (str2 : List Char) (h_precond : LongestCommonPrefix_precond (str1) (str2)) : List Char :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestCommonPrefix_postcond (str1 : List Char) (str2 : List Char) (result: List Char) (h_precond : LongestCommonPrefix_precond (str1) (str2)) :=
  -- !benchmark @start postcond
  (result.length ≤ str1.length) ∧ (result = str1.take result.length) ∧
  (result.length ≤ str2.length) ∧ (result = str2.take result.length) ∧
  (result.length = str1.length ∨ result.length = str2.length ∨
    (str1[result.length]? ≠ str2[result.length]?))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestCommonPrefix_spec_satisfied (str1: List Char) (str2: List Char) (h_precond : LongestCommonPrefix_precond (str1) (str2)) :
    LongestCommonPrefix_postcond (str1) (str2) (LongestCommonPrefix (str1) (str2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
