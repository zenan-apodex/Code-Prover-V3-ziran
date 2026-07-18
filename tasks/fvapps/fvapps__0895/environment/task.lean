import Mathlib

def List.sum : List Nat → Nat 
| [] => 0
| x::xs => x + List.sum xs

def List.minimum : List Nat → Option Nat
| [] => none
| [x] => some x
| x::xs => match List.minimum xs with
  | none => some x
  | some m => some (min x m)

def min_dessert_cost (n : Nat) (costs : List Nat) : Nat := sorry









theorem min_dessert_cost_uniform (n : Nat)
  (h1 : n ≥ 3) :
  min_dessert_cost n (List.replicate n 1) = (n + 1) / 2 := sorry

def alternating_sums (costs : List Nat) : Nat × Nat :=
  let rec helper (xs : List Nat) (isEven : Bool) : Nat × Nat :=
    match xs with
    | [] => (0, 0)
    | x::xs => 
      let (evens, odds) := helper xs (!isEven)
      if isEven then (evens + x, odds)
      else (evens, odds + x)
  helper costs true
