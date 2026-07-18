import Mathlib

def distribute (nodes : Nat) (workload : Nat) : List (List Nat) :=
  sorry

def listMaximum (l : List Nat) : Nat :=
  sorry

def listMinimum (l : List Nat) : Nat :=
  sorry

def listSum (l : List Nat) : Nat :=
  sorry

theorem distribute_length {nodes workload : Nat} 
  (h : nodes ≤ workload ∨ workload = 0) :
  (distribute nodes workload).length = nodes :=
  sorry
