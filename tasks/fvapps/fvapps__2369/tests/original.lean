import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | x :: xs => x + sum xs

def solveCandyBox (n : Nat) (types : List (Nat × Nat)) (flags : List Nat) : Nat × Nat := sorry

theorem all_flagged_small {n : Nat} {types : List (Nat × Nat)} {flags : List Nat}
  (h1 : n = 3)
  (h2 : types = [(1,0), (2,0), (3,0)])
  (h3 : flags = [1,1,1]) :
  let (candies, given) := solveCandyBox n types flags
  given = candies := sorry

theorem none_flagged_small {n : Nat} {types : List (Nat × Nat)} {flags : List Nat}
  (h1 : n = 3)
  (h2 : types = [(1,0), (2,0), (3,0)])
  (h3 : flags = [0,0,0]) :
  let (candies, given) := solveCandyBox n types flags
  given = 0 := sorry

theorem candy_box_properties {n : Nat} {types : List (Nat × Nat)} {flags : List Nat}
  (h1 : n = types.length)
  (h2 : n = flags.length)
  (h3 : ∀ t, t ∈ types → t.1 ≥ 1 ∧ t.1 ≤ 100 ∧ t.2 = 0)
  (h4 : ∀ f, f ∈ flags → f = 0 ∨ f = 1) :
  let (candies, given) := solveCandyBox n types flags
  given ≤ candies ∧ candies ≤ n ∧ given ≤ flags.sum := sorry
