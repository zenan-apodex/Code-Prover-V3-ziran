-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive RemoveDigitsRel : List Char → List Char → Prop
  | nil : RemoveDigitsRel [] []
  | drop {c : Char} {cs rs : List Char} :
      c.isDigit = true →
      RemoveDigitsRel cs rs →
      RemoveDigitsRel (c :: cs) rs
  | keep {c : Char} {cs rs : List Char} :
      c.isDigit = false →
      RemoveDigitsRel cs rs →
      RemoveDigitsRel (c :: cs) (c :: rs)
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemoveDigits_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def RemoveDigits (s : String) (h_precond : RemoveDigits_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def RemoveDigits_postcond (s : String) (result : String)
    (h_precond : RemoveDigits_precond s) : Prop :=
  -- !benchmark @start postcond
  RemoveDigitsRel s.toList result.toList
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem RemoveDigits_spec_satisfied (s : String)
    (h_precond : RemoveDigits_precond s) :
    RemoveDigits_postcond s (RemoveDigits s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof