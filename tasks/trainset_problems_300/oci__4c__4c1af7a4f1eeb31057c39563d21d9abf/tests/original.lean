-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
abbrev WordEntry := String × Int
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def WordFrequency_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
def WordFrequency_words (s : String) : List String :=
  (s.splitOn " ").filter (fun w => w ≠ "")
-- !benchmark @end code_aux

def WordFrequency (s : String) (h_precond : WordFrequency_precond s) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def WordFrequency_postcond (s : String) (result : List (String × Int))
    (h_precond : WordFrequency_precond s) : Prop :=
  -- !benchmark @start postcond
  let words := WordFrequency_words s
  (result.map Prod.fst).Nodup ∧
  (∀ w : String, ∀ n : Int,
    (w, n) ∈ result ↔ n = Int.ofNat (words.count w) ∧ 0 < n)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem WordFrequency_spec_satisfied (s : String)
    (h_precond : WordFrequency_precond s) :
    WordFrequency_postcond s (WordFrequency s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof