-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPalindrome_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsPalindrome (s : String) (h_precond : IsPalindrome_precond s) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def normalizedChars (s : String) : List Char :=
  (s.toList.filter Char.isAlphanum).map Char.toLower
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPalindrome_postcond (s : String) (result : Bool) (h_precond : IsPalindrome_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := normalizedChars s
  (result = true) ↔
    ∀ i : Nat, i < cs.length → cs[i]! = cs[cs.length - 1 - i]!
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsPalindrome_spec_satisfied (s : String) (h_precond : IsPalindrome_precond s) :
    IsPalindrome_postcond s (IsPalindrome s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof