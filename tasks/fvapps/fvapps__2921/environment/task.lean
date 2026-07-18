import Mathlib

structure BlockCount where
  total : Nat
  gold : Nat
  diamond : Nat
  emerald : Nat
  iron : Nat

def blocks_to_collect (level : Nat) : BlockCount :=
  sorry

theorem blocks_total_is_sum_of_others (level : Nat) :
  let result := blocks_to_collect level
  result.total = result.gold + result.diamond + result.emerald + result.iron :=
sorry

theorem values_are_nonnegative (level : Nat) :
  let result := blocks_to_collect level
  result.total ≥ 0 ∧ result.gold ≥ 0 ∧ result.diamond ≥ 0 ∧ result.emerald ≥ 0 ∧ result.iron ≥ 0 :=
sorry

def square (n : Nat) : Nat := n * n

def goldCalc (level : Nat) : Nat := 
  match level with
  | 0 => 0
  | n + 1 => 
    if (n % 4 = 0) then
      square (n + n + 3) + goldCalc n
    else
      goldCalc n

theorem gold_blocks_pattern (level : Nat) :
  let result := blocks_to_collect level
  result.gold = goldCalc level :=
sorry
