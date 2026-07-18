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

theorem len_evens_le {xs: List Nat}: (evens xs).length ≤ xs.length := by sorry
