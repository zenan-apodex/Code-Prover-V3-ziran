-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountWords_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CountWords (input_string : String) (h_precond : CountWords_precond input_string) :
    List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isAsciiAlphaNum (c : Char) : Bool :=
  decide (('a' ≤ c ∧ c ≤ 'z') ∨ ('0' ≤ c ∧ c ≤ '9'))

/-- Lowercase the string, delete all non-alphanumeric/non-space characters,
and then split on spaces, dropping empty tokens. -/
def normalizedWords (s : String) : List String :=
  let cleaned :=
    String.mk <|
      (s.toList.map Char.toLower).filter (fun c => isAsciiAlphaNum c || decide (c = ' '))
  (cleaned.splitOn " ").filter (fun w => w.length > 0)
-- !benchmark @end postcond_aux


@[reducible, simp]
def CountWords_postcond (input_string : String) (result : List (String × Int))
    (h_precond : CountWords_precond input_string) : Prop :=
  -- !benchmark @start postcond
  let ws := normalizedWords input_string
  (∀ p ∈ result, p.2 = Int.ofNat ((ws.filter (· = p.1)).length)) ∧
  (∀ w ∈ ws, ∃ p ∈ result, p.1 = w) ∧
  (∀ p ∈ result, p.1 ∈ ws) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  (∀ p ∈ result, p.2 > 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CountWords_spec_satisfied (input_string : String)
    (h_precond : CountWords_precond input_string) :
    CountWords_postcond input_string (CountWords input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof