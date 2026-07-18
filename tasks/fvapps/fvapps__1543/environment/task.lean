import Mathlib

def solve_atoms (input : List (Nat × Nat) × List Nat) : List Nat := sorry

variable (n : Nat)

def empty_case (n : Nat) : List (Nat × Nat) × List Nat := 
  ([(n, 1)], [0])

def all_case (n : Nat) : List (Nat × Nat) × List Nat :=
  ([(n, 1)], n :: List.range n)

theorem solve_atoms_empty_groups (h : n > 0) :
  solve_atoms (empty_case n) = List.replicate n 1 := sorry

theorem solve_atoms_all_groups (h : n > 0) :
  solve_atoms (all_case n) = List.replicate n 1 := sorry
