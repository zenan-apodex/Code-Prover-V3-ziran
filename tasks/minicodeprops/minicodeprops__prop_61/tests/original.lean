import Mathlib

def last: List Nat → Nat
  | [] => 0
  | [x] => x
  | _x::xs => (last xs)


def lastOfTwo : List ℕ → List ℕ → ℕ
  | xs, [] => last xs
  | _, ys => last ys

theorem prop_61 (xs: List Nat) (ys: List Nat) :
  (last (xs ++ ys) = lastOfTwo xs ys):= by sorry
