import Mathlib

structure CoinChange where
  quarters : Nat
  dimes : Nat
  nickels : Nat
  pennies : Nat

def looseChange (cents : Int) : CoinChange := sorry

theorem loose_change_valid_values (cents : Int) :
  let result := looseChange cents
  result.quarters ≥ 0 ∧ 
  result.dimes ≥ 0 ∧
  result.nickels ≥ 0 ∧ 
  result.pennies ≥ 0 := sorry

theorem loose_change_optimal (cents : Int) (h : cents ≥ 0) (h2 : cents ≤ 1000) :
  let result := looseChange cents
  result.pennies < 5 ∧ 
  result.nickels < 2 ∧ 
  result.dimes < 3 ∧
  result.quarters * 25 + result.dimes * 10 + result.nickels * 5 + result.pennies = cents := sorry
