import Mathlib

def Action : Type := (String × Nat)
def Actions : Type := List Action

def solve_order_book (actions: Actions) : Nat := sorry



theorem solve_multiple_possibilities :
  let test_actions := [("ADD", 5), ("ADD", 5), ("ACCEPT", 5)]
  solve_order_book test_actions = 2 := sorry
