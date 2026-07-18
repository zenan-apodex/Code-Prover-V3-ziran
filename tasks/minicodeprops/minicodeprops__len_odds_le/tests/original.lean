import Mathlib

mutual
  def evens : List Nat → List Nat
  | [] => []
  | x::xs => x::(odds xs)
--
  def odds : List Nat → List Nat
  | [] => []
  | _x::xs => evens xs
end

theorem len_odds_le {xs: List Nat}: (odds xs).length ≤ xs.length := by sorry
