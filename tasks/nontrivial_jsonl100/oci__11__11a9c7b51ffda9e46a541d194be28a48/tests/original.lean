-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def TopFiveCommonWords_precond (text : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def TopFiveCommonWords (text : String) (h_precond : TopFiveCommonWords_precond text) : List (String × Nat) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Remove punctuation (keep only alphanumeric and whitespace) and lowercase -/
def cleanText (text : String) : String :=
  String.mk ((text.toList.filter (fun c => c.isAlphanum || c == ' ')).map Char.toLower)

/-- Split cleaned text into words, dropping empty tokens -/
def getWords (text : String) : List String :=
  ((cleanText text).splitOn " ").filter (fun w => w.length > 0)

/-- Count occurrences of a word in a word list -/
def wordCount (w : String) (ws : List String) : Nat :=
  (ws.filter (· == w)).length

/-- Bool comparison for sorting: first by count descending, then lexicographically ascending -/
def wordCountLeBool (a b : String × Nat) : Bool :=
  if a.2 > b.2 then true
  else if a.2 = b.2 then decide (a.1 ≤ b.1)
  else false
-- !benchmark @end postcond_aux


@[reducible, simp]
def TopFiveCommonWords_postcond (text : String) (result : List (String × Nat))
    (h_precond : TopFiveCommonWords_precond text) : Prop :=
  -- !benchmark @start postcond
  let ws := getWords text
  -- No duplicate keys
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  -- Each entry has correct count
  (∀ p ∈ result, p.2 = wordCount p.1 ws) ∧
  -- Each entry's word is actually in the input
  (∀ p ∈ result, p.1 ∈ ws) ∧
  -- Result is sorted by count desc, then lexicographically
  List.Pairwise (fun a b => wordCountLeBool a b = true) result ∧
  -- Result length is at most 5
  result.length ≤ 5 ∧
  -- All words NOT in result have count ≤ the minimum count in result
  (∀ w ∈ ws, (∃ p ∈ result, p.1 = w) ∨
    (result.length = 5 ∧ ∀ p ∈ result, wordCount w ws < p.2 ∨
      (wordCount w ws = p.2 ∧ decide (w ≥ p.1) = true))) ∧
  -- Counts are positive
  (∀ p ∈ result, p.2 > 0) ∧
  -- If there are fewer than 5 unique words, all are included
  ((ws.dedup.length ≤ 5) → (∀ w ∈ ws, ∃ p ∈ result, p.1 = w))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem TopFiveCommonWords_spec_satisfied (text : String) (h_precond : TopFiveCommonWords_precond text) :
    TopFiveCommonWords_postcond text (TopFiveCommonWords text h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof