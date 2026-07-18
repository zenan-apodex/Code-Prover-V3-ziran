import Mathlib

def splitAt : Nat → List Nat → (List Nat × List Nat)
| _n, [] => ([], [])
| 0, xs => ([], xs)
| n + 1, x::xs => match splitAt n xs with
  | (l1, l2) => (x::l1, l2)

theorem splitAt_second_len_lt' {xs: List Nat} (n: Nat) (hlen: xs.length > 0): (splitAt n.succ xs).2.length < xs.length := by sorry
