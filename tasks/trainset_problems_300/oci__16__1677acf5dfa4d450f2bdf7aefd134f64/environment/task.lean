-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def KeysUnique (d : List (String × String)) : Prop :=
  List.Pairwise (fun a b => a.1 ≠ b.1) d
-- !benchmark @end precond_aux

@[reducible, simp]
def ConvertValuesToUppercase_precond (data : List (List (String × String))) : Prop :=
  -- !benchmark @start precond
  ∀ d ∈ data, KeysUnique d
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ConvertValuesToUppercase (data : List (List (String × String)))
    (h_precond : ConvertValuesToUppercase_precond data) : List (List (String × String)) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def DictUppercaseOf (input output : List (String × String)) : Prop :=
  KeysUnique output ∧
  (∀ p ∈ input, ∃ q ∈ output, q.1 = p.1 ∧ q.2 = String.toUpper p.2) ∧
  (∀ q ∈ output, ∃ p ∈ input, q.1 = p.1 ∧ q.2 = String.toUpper p.2)
-- !benchmark @end postcond_aux


@[reducible, simp]
def ConvertValuesToUppercase_postcond (data : List (List (String × String)))
    (result : List (List (String × String)))
    (h_precond : ConvertValuesToUppercase_precond data) : Prop :=
  -- !benchmark @start postcond
  result.length = data.length ∧
  ∀ i : Nat, i < data.length → DictUppercaseOf (data[i]!) (result[i]!)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ConvertValuesToUppercase_spec_satisfied (data : List (List (String × String)))
    (h_precond : ConvertValuesToUppercase_precond data) :
    ConvertValuesToUppercase_postcond data (ConvertValuesToUppercase data h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof