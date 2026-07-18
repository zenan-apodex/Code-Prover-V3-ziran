-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FilterPalindromes_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FilterPalindromes (strings : List String) (h_precond : FilterPalindromes_precond strings) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsPalindromeString (s : String) : Prop :=
  s.toList.reverse = s.toList

inductive FilterPalindromesRel : List String → List String → Prop
| nil : FilterPalindromesRel [] []
| keep {s : String} {xs ys : List String} :
    IsPalindromeString s →
    FilterPalindromesRel xs ys →
    FilterPalindromesRel (s :: xs) (s :: ys)
| drop {s : String} {xs ys : List String} :
    ¬ IsPalindromeString s →
    FilterPalindromesRel xs ys →
    FilterPalindromesRel (s :: xs) ys
-- !benchmark @end postcond_aux


@[reducible, simp]
def FilterPalindromes_postcond (strings : List String) (result : List String)
    (h_precond : FilterPalindromes_precond strings) : Prop :=
  -- !benchmark @start postcond
  FilterPalindromesRel strings result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FilterPalindromes_spec_satisfied (strings : List String)
    (h_precond : FilterPalindromes_precond strings) :
    FilterPalindromes_postcond strings (FilterPalindromes strings h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof