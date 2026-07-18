import Mathlib

theorem prop_05 (n: Nat) (x: Nat) (xs: List Nat) :
 (n = x) →  (List.count n xs).succ = List.count n (x :: xs):= by sorry
