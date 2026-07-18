import Mathlib

def reverse : List Nat → List Nat
| [] => []
| x::xs => (reverse xs) ++ [x]

theorem len_rev_eq_len {l: List Nat} : (reverse l).length = l.length := by sorry
