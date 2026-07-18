import Mathlib

def butlast : List α → List α
  | [] => []
  | [_x] => []
  | x::xs => x::(butlast xs)


def butlastConcat : List α → List α → List α
  | xs, [] => butlast xs
  | xs, ys => xs ++ butlast ys

theorem prop_49 (xs: List Nat) (ys: List Nat) :
  (butlast (xs ++ ys) = butlastConcat xs ys):= by sorry
