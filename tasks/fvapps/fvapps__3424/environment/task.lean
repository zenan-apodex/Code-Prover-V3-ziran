import Mathlib

def digitize (n : Nat) : List Nat := sorry 

theorem digitize_length (n : Nat) : 
  List.length (digitize n) = String.length (toString n) := sorry

theorem digitize_values (n : Nat) :
  ∀ d ∈ digitize n, d ≤ 9 := sorry

theorem digitize_reconstruction (n : Nat) :
  let digits := digitize n
  String.toNat! (String.intercalate "" (List.map toString digits)) = n := sorry

theorem digitize_zero : digitize 0 = [0] := sorry
