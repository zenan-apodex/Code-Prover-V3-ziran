-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def StringsWithLengths_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def StringsWithLengths (strings : List String) (h_precond : StringsWithLengths_precond strings) :
    List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
inductive StringsWithLengthsRel : List String → List (String × Int) → Prop where
  | nil : StringsWithLengthsRel [] []
  | cons (s : String) (ss : List String) (r : List (String × Int)) :
      StringsWithLengthsRel ss r →
      StringsWithLengthsRel (s :: ss) ((s, Int.ofNat s.length) :: r)
-- !benchmark @end postcond_aux

@[reducible, simp]
def StringsWithLengths_postcond (strings : List String) (result : List (String × Int))
    (h_precond : StringsWithLengths_precond strings) : Prop :=
  -- !benchmark @start postcond
  StringsWithLengthsRel strings result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem StringsWithLengths_spec_satisfied (strings : List String)
    (h_precond : StringsWithLengths_precond strings) :
    StringsWithLengths_postcond strings (StringsWithLengths strings h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof