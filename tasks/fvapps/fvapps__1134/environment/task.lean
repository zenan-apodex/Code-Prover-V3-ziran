import Mathlib

inductive BattleResult
| VICTORY
| DEFEAT

def List.sum : List Nat → Nat 
| [] => 0
| (x::xs) => x + sum xs

def check_conquest (n m : Nat) (armies : List Nat) : BattleResult := sorry

theorem check_conquest_valid_result (n m : Nat) (armies : List Nat) :
  check_conquest n m armies = BattleResult.VICTORY ∨ 
  check_conquest n m armies = BattleResult.DEFEAT := sorry

theorem check_conquest_enough_armies (n m : Nat) (armies : List Nat) :
  n ≤ m → check_conquest n m armies = BattleResult.VICTORY := sorry

theorem check_conquest_insufficient_armies (n m : Nat) (armies : List Nat) :
  n > m → (List.take m armies).sum ≤ 0 → 
  check_conquest n m armies = BattleResult.DEFEAT := sorry

theorem check_conquest_monotone (n m : Nat) (armies : List Nat) :
  n > m →
  check_conquest n m armies = BattleResult.VICTORY →
  check_conquest n m (armies.map (· + 1)) = BattleResult.VICTORY := sorry
