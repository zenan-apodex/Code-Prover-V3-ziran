import Mathlib

def max_tri_sum (nums : List Int) : Int := 
sorry

def List.sort (lt : α → α → Bool) : List α → List α :=
sorry

def List.sum : List Int → Int :=
sorry

def List.dedup : List α → List α :=
sorry



theorem max_tri_sum_perm_invariant {nums₁ nums₂ : List Int} 
  (h₁ : nums₁.length ≥ 3)
  (h₂ : nums₂.length ≥ 3)
  (h_perm : List.Perm nums₁ nums₂) : 
  max_tri_sum nums₁ = max_tri_sum nums₂ := sorry
