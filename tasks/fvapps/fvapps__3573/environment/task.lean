import Mathlib

def solve (chips : List Nat) : Nat := sorry

def listSum : List Nat → Nat 
| [] => 0
| x::xs => x + listSum xs

def listMin : List Nat → Nat
| [] => 0
| [x] => x
| x::xs => min x (listMin xs)

def secondMin : List Nat → Nat
| [] => 0
| [_] => 0
| l => 
  let m := listMin l
  listMin (l.filter (fun x => x ≠ m))







theorem solve_two_identical_bounded (a b : Nat)
  (h₁ : a > 0)
  (h₂ : b > 0) :
  solve [a, a, b] ≤ (a + a + b) / 2 := sorry
