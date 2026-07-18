-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemoveVowels_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def RemoveVowels (input_string : String) (h_precond : RemoveVowels_precond input_string) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsVowel (c : Char) : Prop :=
  c = 'a' ∨ c = 'e' ∨ c = 'i' ∨ c = 'o' ∨ c = 'u' ∨
  c = 'A' ∨ c = 'E' ∨ c = 'I' ∨ c = 'O' ∨ c = 'U'

inductive VowelsRemoved : List Char → List Char → Prop where
  | nil : VowelsRemoved [] []
  | drop {c : Char} {cs ds : List Char} :
      IsVowel c →
      VowelsRemoved cs ds →
      VowelsRemoved (c :: cs) ds
  | keep {c : Char} {cs ds : List Char} :
      ¬ IsVowel c →
      VowelsRemoved cs ds →
      VowelsRemoved (c :: cs) (c :: ds)
-- !benchmark @end postcond_aux


@[reducible, simp]
def RemoveVowels_postcond (input_string : String) (result : String)
    (h_precond : RemoveVowels_precond input_string) : Prop :=
  -- !benchmark @start postcond
  VowelsRemoved input_string.toList result.toList
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem RemoveVowels_spec_satisfied (input_string : String)
    (h_precond : RemoveVowels_precond input_string) :
    RemoveVowels_postcond input_string (RemoveVowels input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof