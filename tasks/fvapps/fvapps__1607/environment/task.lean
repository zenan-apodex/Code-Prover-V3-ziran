import Mathlib

def count_qaq_subsequences (s : String) : Nat :=
  sorry

theorem count_qaq_subsequences_nonnegative (s : String) :
  count_qaq_subsequences s ≥ 0 :=
  sorry



theorem count_qaq_subsequences_lt_two_q (s : String) :
  (s.data.filter (· = 'Q')).length < 2 →
  count_qaq_subsequences s = 0 :=
  sorry
