import Mathlib

def you_are_a_cube (n : Nat) : Bool := sorry

theorem cubes_identified_correctly (n : Nat) :
  let cube_root := n^(1/3)
  you_are_a_cube n = (cube_root^3 = n) :=
sorry

theorem explicit_cubes_true (n : Nat) :
  you_are_a_cube (n * n * n) = true :=
sorry
