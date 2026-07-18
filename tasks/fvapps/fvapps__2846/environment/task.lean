import Mathlib

def abs (n : Int) : Int :=
  sorry

def sum (lst : List Int) : Int :=
  sorry

def modified_sum (lst : List Int) (p : Nat) : Int :=
  sorry

theorem modified_sum_p_one {lst : List Int} (h : lst ≠ []) : 
  modified_sum lst 1 = 0 := sorry
