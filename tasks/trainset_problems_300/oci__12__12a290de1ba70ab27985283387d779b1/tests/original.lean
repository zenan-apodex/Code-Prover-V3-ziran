-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsValidPhoneNumber_precond (phone_number : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsValidPhoneNumber (phone_number : String) (h_precond : IsValidPhoneNumber_precond phone_number) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsDigitChar (c : Char) : Prop :=
  c = '0' ∨ c = '1' ∨ c = '2' ∨ c = '3' ∨ c = '4' ∨
  c = '5' ∨ c = '6' ∨ c = '7' ∨ c = '8' ∨ c = '9'
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsValidPhoneNumber_postcond (phone_number : String) (result : Bool)
    (h_precond : IsValidPhoneNumber_precond phone_number) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔
    phone_number.length = 10 ∧
    (∀ c ∈ phone_number.toList, IsDigitChar c)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsValidPhoneNumber_spec_satisfied (phone_number : String)
    (h_precond : IsValidPhoneNumber_precond phone_number) :
    IsValidPhoneNumber_postcond phone_number (IsValidPhoneNumber phone_number h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof