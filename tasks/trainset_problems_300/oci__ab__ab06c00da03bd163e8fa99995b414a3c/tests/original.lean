-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemovePunctuation_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def RemovePunctuation (input_string : String) (h_precond : RemovePunctuation_precond input_string) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsPunctuation (c : Char) : Prop :=
  c = '!' ∨ c = '"' ∨ c = '#' ∨ c = '$' ∨ c = '%' ∨ c = '&' ∨ c = '\'' ∨
  c = '(' ∨ c = ')' ∨ c = '*' ∨ c = '+' ∨ c = ',' ∨ c = '-' ∨ c = '.' ∨
  c = '/' ∨ c = ':' ∨ c = ';' ∨ c = '<' ∨ c = '=' ∨ c = '>' ∨ c = '?' ∨
  c = '@' ∨ c = '[' ∨ c = '\\' ∨ c = ']' ∨ c = '^' ∨ c = '_' ∨ c = '`' ∨
  c = '{' ∨ c = '|' ∨ c = '}' ∨ c = '~'

inductive RemovesPunctuation : List Char → List Char → Prop where
  | nil : RemovesPunctuation [] []
  | drop {c : Char} {xs ys : List Char} :
      IsPunctuation c →
      RemovesPunctuation xs ys →
      RemovesPunctuation (c :: xs) ys
  | keep {c : Char} {xs ys : List Char} :
      ¬ IsPunctuation c →
      RemovesPunctuation xs ys →
      RemovesPunctuation (c :: xs) (c :: ys)
-- !benchmark @end postcond_aux


@[reducible, simp]
def RemovePunctuation_postcond (input_string : String) (result : String) (h_precond : RemovePunctuation_precond input_string) : Prop :=
  -- !benchmark @start postcond
  RemovesPunctuation input_string.toList result.toList
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem RemovePunctuation_spec_satisfied (input_string : String) (h_precond : RemovePunctuation_precond input_string) :
    RemovePunctuation_postcond input_string (RemovePunctuation input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof