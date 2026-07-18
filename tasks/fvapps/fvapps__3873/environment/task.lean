import Mathlib

def List.product (l : List Int) : Int := sorry 

def product_sans_n (nums : List Int) : List Int := sorry

def count_zeros (l : List Int) : Nat :=
  l.filter (· = 0) |>.length

theorem product_sans_n_length {nums : List Int} (h : nums ≠ []) : 
  (product_sans_n nums).length = nums.length := sorry
