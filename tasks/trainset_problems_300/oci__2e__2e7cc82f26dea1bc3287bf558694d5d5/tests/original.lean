-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CheckPalindrome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CheckPalindrome (s : String) (h_precond : CheckPalindrome_precond s) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def normalizeChars (s : String) : List Char :=
  (s.toList.filter (fun c => c.isAlphanum)).map (fun c => c.toLower)
-- !benchmark @end postcond_aux


@[reducible, simp]
def CheckPalindrome_postcond (s : String) (result : Bool)
    (h_precond : CheckPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  let ns := normalizeChars s
  (result = true) ↔ ns = ns.reverse
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CheckPalindrome_spec_satisfied (s : String)
    (h_precond : CheckPalindrome_precond s) :
    CheckPalindrome_postcond s (CheckPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof