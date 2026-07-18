import Mathlib

inductive Operation where
  | RowAdd : Nat → Nat → Operation 
  | ColAdd : Nat → Nat → Operation
deriving Repr

inductive Perm : List α → List α → Prop where
  | nil  : Perm [] []
  | skip : Perm xs ys → Perm (x::xs) (x::ys)
  | swap : Perm (y::x::xs) (x::y::xs)
  | trans : Perm xs ys → Perm ys zs → Perm xs zs

def find_max_after_operations (n: Nat) (ops: List Operation) : Nat :=
  sorry



theorem empty_ops_is_zero (n: Nat) : 
  find_max_after_operations n [] = 0 :=
  sorry
