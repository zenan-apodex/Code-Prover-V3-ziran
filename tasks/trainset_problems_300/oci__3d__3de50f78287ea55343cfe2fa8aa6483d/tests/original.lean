-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
abbrev PalindromeString (s : String) : Prop :=
  s.toList = s.toList.reverse
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ClassifyPalindromes_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def ClassifyPalindromes (strings : List String) (h_precond : ClassifyPalindromes_precond strings) :
    List (String × Bool) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def ClassifyPalindromesRel (s : String) (p : String × Bool) : Prop :=
  p.1 = s ∧ (p.2 = true ↔ PalindromeString s)
-- !benchmark @end postcond_aux

@[reducible, simp]
def ClassifyPalindromes_postcond (strings : List String) (result : List (String × Bool))
    (h_precond : ClassifyPalindromes_precond strings) : Prop :=
  -- !benchmark @start postcond
  List.Forall₂ ClassifyPalindromesRel strings result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem ClassifyPalindromes_spec_satisfied (strings : List String)
    (h_precond : ClassifyPalindromes_precond strings) :
    ClassifyPalindromes_postcond strings (ClassifyPalindromes strings h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof