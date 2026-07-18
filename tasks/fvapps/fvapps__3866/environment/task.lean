import Mathlib

structure Candidate where
  name : String
  scores : List Nat
deriving Repr

def winner : List Candidate → Option String := sorry

theorem invalid_candidate_count 
  {cs : List Candidate} : 
  cs.length ≠ 3 → winner cs = none := sorry

theorem invalid_scores 
  {cs : List Candidate}
  (h_length : cs.length = 3)
  (h_invalid : ∃ c, c ∈ cs ∧ ∃ s, s ∈ c.scores ∧ ¬(s % 5 = 0 ∧ 5 ≤ s ∧ s ≤ 100)) :
  winner cs = none := sorry
