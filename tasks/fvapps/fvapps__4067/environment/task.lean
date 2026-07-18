import Mathlib

def iq_test (input : String) : Nat :=
  sorry



theorem iq_test_edge_position_start :
  iq_test "1 2 2 2" = 1 ∧ 
  iq_test "2 1 1 1" = 1 :=
sorry

theorem iq_test_edge_position_end :
  iq_test "2 2 2 1" = 4 ∧
  iq_test "1 1 1 2" = 4 :=
sorry
