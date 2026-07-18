import Mathlib

def sumin (n : Nat) : Nat := sorry
def sumax (n : Nat) : Nat := sorry
def sumsum (n : Nat) : Nat := sorry

def sumOfMins (n : Nat) : Nat := sorry



theorem sumin_positive (n : Nat) (h : n > 0) : 
  sumin n > 0 :=
sorry

theorem sumin_le_sumax (n : Nat) :
  sumin n ≤ sumax n :=
sorry

def sumOfMaxs (n : Nat) : Nat := sorry



theorem sumax_positive (n : Nat) (h : n > 0) :
  sumax n > 0 :=
sorry

theorem sumax_ge_sumin (n : Nat) :
  sumax n ≥ sumin n :=
sorry

def sumOfSums (n : Nat) : Nat := sorry



theorem sumsum_equals_sumin_plus_sumax (n : Nat) :
  sumsum n = sumin n + sumax n :=
sorry

theorem sumsum_positive (n : Nat) (h : n > 0) :
  sumsum n > 0 :=
sorry
