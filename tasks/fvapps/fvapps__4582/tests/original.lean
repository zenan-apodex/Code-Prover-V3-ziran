import Mathlib

def group (arr : List Int) : List (List Int) := sorry

def listSum (xs : List Nat) : Nat := 
  match xs with
  | [] => 0
  | h :: t => h + listSum t

def listSort (xs : List Int) : List Int := sorry

def listIndexOf (xs : List Int) (x : Int) : Nat := sorry



theorem group_idempotent {arr : List Int} (h : arr ≠ []) :
  let result1 := group arr;
  let flattened := result1.join;
  let result2 := group flattened;
  result1 = result2 :=
sorry
