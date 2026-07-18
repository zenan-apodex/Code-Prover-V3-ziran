import Mathlib

def splitAt : Nat → List Nat → (List Nat × List Nat)
| _n, [] => ([], [])
| 0, xs => ([], xs)
| n + 1, x::xs => match splitAt n xs with
  | (l1, l2) => (x::l1, l2)

theorem splitAt_first_len_lt {xs: List Nat} (hn: n < xl) (hlen': xl = xs.length): (splitAt n xs).1.length < xl := by sorry
