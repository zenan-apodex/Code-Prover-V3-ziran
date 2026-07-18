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

theorem bmerge_term2 (x y: Nat) (xs ys: List Nat) : List.length (odds (x :: xs)) + List.length (odds (y :: ys)) < Nat.succ (List.length xs) + Nat.succ (List.length ys) := by sorry
