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

theorem bmerge_term (a b: Nat) (as bs: List Nat) (hlen: ¬(List.length as == 0 && List.length bs == 0) = true): List.length (evens (a :: as)) + List.length (evens (b :: bs)) < Nat.succ (List.length as) + Nat.succ (List.length bs) := by sorry
