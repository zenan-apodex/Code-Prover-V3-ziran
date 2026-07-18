import Mathlib

def max_product (nums : List Nat) : Nat :=
  sorry









theorem max_product_two_elements (a b : Nat)
  (h1 : 2 ≤ a ∧ a ≤ 1000)
  (h2 : 2 ≤ b ∧ b ≤ 1000) :
  max_product [a, b] = (a-1) * (b-1) := sorry
