-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def WordFrequencies_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def WordFrequencies (s : String) (h_precond : WordFrequencies_precond s) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def flushCurrentWord (current : List Char) (acc : List String) : List String :=
  if current = [] then
    acc
  else
    acc ++ [String.mk current.reverse]

def collectWordsAux : List Char → List Char → List String → List String
  | [], current, acc =>
      flushCurrentWord current acc
  | c :: cs, current, acc =>
      if c.isAlphanum then
        collectWordsAux cs (c.toLower :: current) acc
      else
        collectWordsAux cs [] (flushCurrentWord current acc)

def tokenizeWords (s : String) : List String :=
  collectWordsAux s.toList [] []
-- !benchmark @end postcond_aux


@[reducible, simp]
def WordFrequencies_postcond (s : String) (result : List (String × Int))
    (h_precond : WordFrequencies_precond s) : Prop :=
  -- !benchmark @start postcond
  let ws := tokenizeWords s
  (∀ p ∈ result, p.2 = Int.ofNat ((ws.filter (· = p.1)).length)) ∧
  (∀ w ∈ ws, ∃ p ∈ result, p.1 = w) ∧
  (∀ p ∈ result, p.1 ∈ ws) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  (∀ p ∈ result, p.2 > 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem WordFrequencies_spec_satisfied (s : String) (h_precond : WordFrequencies_precond s) :
    WordFrequencies_postcond s (WordFrequencies s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof