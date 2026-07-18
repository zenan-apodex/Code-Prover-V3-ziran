import Mathlib

def pairs : List α → List (α × α)
  | x::y::xs => (x, y):: (pairs xs)
  | _ => []


mutual
  def evens : List α → List α
  | [] => []
  | x::xs => x::(odds xs)
  def odds : List α → List α
  | [] => []
  | _x::xs => evens xs
end

theorem prop_PairOdds (xs: List α) [DecidableEq α] :
  List.map Prod.snd (pairs xs) == odds xs:= by sorry
