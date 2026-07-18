import Mathlib

def max_efficiency_workgroup (n : Nat) (superiors : List Int) (efficiencies : List Int) : Int :=
sorry



theorem single_node_case (efficiency : Int) (h : -100 ≤ efficiency ∧ efficiency ≤ 100) :
  max_efficiency_workgroup 1 [-1] [efficiency] = efficiency :=
sorry
