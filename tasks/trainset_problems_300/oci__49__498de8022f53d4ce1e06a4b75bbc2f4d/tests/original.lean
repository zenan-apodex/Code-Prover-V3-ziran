-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountCharFrequency_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
def charCount (s : String) (c : Char) : Int :=
  ((s.toList.count c) : Nat)

def keyRepresentsChar (k : String) (c : Char) : Prop :=
  k = c.toString
-- !benchmark @end code_aux

def CountCharFrequency (input_string : String) (h_precond : CountCharFrequency_precond input_string) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def KeysUnique (result : List (String × Int)) : Prop :=
  result.Pairwise (fun a b => a.1 ≠ b.1)
-- !benchmark @end postcond_aux

@[reducible, simp]
def CountCharFrequency_postcond (input_string : String) (result : List (String × Int))
    (h_precond : CountCharFrequency_precond input_string) : Prop :=
  -- !benchmark @start postcond
  KeysUnique result ∧
  (∀ entry ∈ result,
    ∃ c : Char,
      keyRepresentsChar entry.1 c ∧
      entry.2 = charCount input_string c ∧
      0 < entry.2) ∧
  (∀ c : Char,
    c ∈ input_string.toList ↔
      ∃ n : Int, (c.toString, n) ∈ result ∧ n = charCount input_string c)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem CountCharFrequency_spec_satisfied (input_string : String)
    (h_precond : CountCharFrequency_precond input_string) :
    CountCharFrequency_postcond input_string (CountCharFrequency input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof