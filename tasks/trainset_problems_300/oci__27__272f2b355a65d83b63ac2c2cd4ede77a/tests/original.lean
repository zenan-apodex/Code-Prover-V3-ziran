-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def StringToAscii_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def StringToAscii (input_string : String) (h_precond : StringToAscii_precond input_string) :
    List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def StringToAscii_postcond (input_string : String) (result : List Int)
    (h_precond : StringToAscii_precond input_string) : Prop :=
  -- !benchmark @start postcond
  let cs := input_string.toList
  result.length = cs.length ∧
  ∀ i : Nat, i < cs.length → result[i]! = Int.ofNat cs[i]!.toNat
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem StringToAscii_spec_satisfied (input_string : String)
    (h_precond : StringToAscii_precond input_string) :
    StringToAscii_postcond input_string (StringToAscii input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof