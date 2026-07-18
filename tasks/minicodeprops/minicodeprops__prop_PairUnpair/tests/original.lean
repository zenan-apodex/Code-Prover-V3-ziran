import Mathlib

def pairs : List α → List (α × α)
  | x::y::xs => (x, y):: (pairs xs)
  | _ => []


def unpair : List (α × α) → List α
  | [] => []
  | (x, y)::xs => x :: y :: (unpair xs)

theorem prop_PairUnpair (xs: List α) [DecidableEq α] :
  Even (xs.length) → ((unpair (pairs xs)) == xs):= by sorry
