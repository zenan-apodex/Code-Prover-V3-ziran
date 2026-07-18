import Mathlib

def List.sum (l : List Int) : Int :=
  sorry

def Nat.toInt (n : Nat) : Int :=
  sorry

def find_pivot_index (nums : List Int) : Int :=
  sorry





theorem pivot_index_empty :
  find_pivot_index [] = -1 := sorry

theorem pivot_index_single {n : Int} :
  find_pivot_index [n] = 0 := sorry
