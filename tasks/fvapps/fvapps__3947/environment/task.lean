import Mathlib

def square_digits (n : Nat) : Nat := sorry

def digits_to_nat (digits : List Nat) : Nat := sorry

def nat_to_digits (n : Nat) : List Nat := sorry

def square_len (n : Nat) : Nat := toString (n * n) |>.length 

def listSum : List Nat → Nat 
| [] => 0
| x :: xs => x + listSum xs







theorem single_digit_square {d : Nat} (h : d ≤ 9) :
  square_digits d = d * d :=
sorry
