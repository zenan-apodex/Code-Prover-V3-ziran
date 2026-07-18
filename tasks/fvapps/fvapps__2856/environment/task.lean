import Mathlib

def gap (n : Nat) : Nat := sorry

theorem gap_bounded (n : Nat) (h : n > 0):
  gap n ≤ n.log2 :=
sorry

theorem no_gaps_all_ones (n : Nat):
  gap ((1 <<< n) - 1) = 0 :=
sorry

theorem leading_trailing_zeros (n k : Nat) (h : n > 0):
  gap n = gap (n <<< k) :=
sorry

theorem single_bit_no_gap (n : Nat):
  gap (1 <<< n) = 0 :=
sorry
