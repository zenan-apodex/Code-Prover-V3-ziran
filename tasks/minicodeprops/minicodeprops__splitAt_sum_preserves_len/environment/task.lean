import Mathlib

def splitAt : Nat → List Nat → (List Nat × List Nat)
| _n, [] => ([], [])
| 0, xs => ([], xs)
| n + 1, x::xs => match splitAt n xs with
  | (l1, l2) => (x::l1, l2)

theorem splitAt_sum_preserves_len (n: Nat) (xs: List Nat) (hspl: spl = splitAt n xs): (spl.1.length + spl.2.length = xs.length) := by sorry
