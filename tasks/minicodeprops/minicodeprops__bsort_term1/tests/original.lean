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

theorem bsort_term1 (x y: Nat) (xs: List Nat): List.length (evens (x :: y :: xs)) < Nat.succ (Nat.succ (List.length xs)) := by sorry
