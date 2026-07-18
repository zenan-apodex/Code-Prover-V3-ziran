import Mathlib

def splitAt : Nat → List Nat → (List Nat × List Nat)
| _n, [] => ([], [])
| 0, xs => ([], xs)
| n + 1, x::xs => match splitAt n xs with
  | (l1, l2) => (x::l1, l2)

theorem splitAt_second_len_lt'' {xs: List Nat} (hn: n > 0) (hlen: xs.length > 0) (hlen': xl = xs.length): (splitAt n xs).2.length < xl := by sorry
