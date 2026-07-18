-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def StringToAsciiDict_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def StringToAsciiDict (input_string : String) (h_precond : StringToAsciiDict_precond input_string) :
    List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def charKey (c : Char) : String :=
  String.singleton c
-- !benchmark @end postcond_aux


@[reducible, simp]
def StringToAsciiDict_postcond (input_string : String) (result : List (String × Int))
    (h_precond : StringToAsciiDict_precond input_string) : Prop :=
  -- !benchmark @start postcond
  let cs := input_string.toList
  (∀ p ∈ result, ∃ c ∈ cs, p.1 = charKey c ∧ p.2 = Int.ofNat c.toNat) ∧
  (∀ c ∈ cs, ∃ p ∈ result, p.1 = charKey c ∧ p.2 = Int.ofNat c.toNat) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem StringToAsciiDict_spec_satisfied (input_string : String)
    (h_precond : StringToAsciiDict_precond input_string) :
    StringToAsciiDict_postcond input_string (StringToAsciiDict input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof