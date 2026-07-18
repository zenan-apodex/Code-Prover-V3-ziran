-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CleanStrings_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def CleanStrings (strings : List String) (h_precond : CleanStrings_precond strings) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def CleanedStringRel (s t : String) : Prop :=
  t = s.trim.toLower
-- !benchmark @end postcond_aux

@[reducible, simp]
def CleanStrings_postcond (strings : List String) (result : List String)
    (h_precond : CleanStrings_precond strings) : Prop :=
  -- !benchmark @start postcond
  List.Forall₂ CleanedStringRel strings result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem CleanStrings_spec_satisfied (strings : List String)
    (h_precond : CleanStrings_precond strings) :
    CleanStrings_postcond strings (CleanStrings strings h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof