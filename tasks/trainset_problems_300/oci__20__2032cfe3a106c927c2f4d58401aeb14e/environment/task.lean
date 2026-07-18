-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountVowels_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CountVowels (s : String) (h_precond : CountVowels_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsVowel (c : Char) : Prop :=
  c = 'a' ∨ c = 'e' ∨ c = 'i' ∨ c = 'o' ∨ c = 'u' ∨
  c = 'A' ∨ c = 'E' ∨ c = 'I' ∨ c = 'O' ∨ c = 'U'

def VowelIndicesFor (cs : List Char) (idxs : List Nat) : Prop :=
  idxs.Nodup ∧
  (∀ i : Nat, i ∈ idxs → i < cs.length ∧ IsVowel (cs[i]!)) ∧
  (∀ i : Nat, i < cs.length → IsVowel (cs[i]!) → i ∈ idxs)
-- !benchmark @end postcond_aux


@[reducible, simp]
def CountVowels_postcond (s : String) (result : Int) (h_precond : CountVowels_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  ∃ idxs : List Nat, VowelIndicesFor cs idxs ∧ result = Int.ofNat (idxs.length)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CountVowels_spec_satisfied (s : String) (h_precond : CountVowels_precond s) :
    CountVowels_postcond s (CountVowels s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof