import Mathlib

mutual
  def evens : List α → List α
  | [] => []
  | x::xs => x::(odds xs)
  def odds : List α → List α
  | [] => []
  | _x::xs => evens xs
end


def interleave : List α → List α → List α
  | (x::xs), ys => x :: interleave ys xs
  | [],      ys => ys
termination_by xs ys => xs.length + ys.length

theorem prop_interleave (xs: List α) [DecidableEq α] :
  interleave (evens xs) (odds xs) == xs:= by sorry
