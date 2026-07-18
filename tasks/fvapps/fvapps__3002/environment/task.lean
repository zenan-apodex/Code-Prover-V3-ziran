import Mathlib

def is_pronic (n : Int) : Bool :=
  sorry

theorem pronic_exists_k {n : Int} (h : is_pronic n) : 
  ∃ k : Int, k * (k + 1) = n :=
  sorry

theorem negative_not_pronic {n : Int} (h : n < 0) :
  ¬ is_pronic n :=
  sorry

theorem consecutive_product_is_pronic (n : Int) (h : n ≥ 0) :
  is_pronic (n * (n + 1)) :=
  sorry
