import Mathlib

def calc_jumps_in_60_secs (failed_counts : List Nat) : Nat :=
  sorry



theorem empty_list_returns_sixty :
  calc_jumps_in_60_secs [] = 60 :=
  sorry

theorem example_case_single :
  calc_jumps_in_60_secs [17] = 57 :=
  sorry

theorem example_case_multiple :
  calc_jumps_in_60_secs [12, 23, 45] = 51 :=
  sorry
