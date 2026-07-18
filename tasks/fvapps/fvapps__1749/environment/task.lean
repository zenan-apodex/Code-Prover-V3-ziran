import Mathlib

def isqrt (n : Nat) : Nat := sorry 

def isPrime (p : Nat) : Bool := sorry

structure PrimeFactor where
  prime : Nat
  power : Nat

def factorize (n : Nat) : List PrimeFactor := sorry

theorem isqrt_upper_bound (n : Nat) (h : n > 0) : 
  let r := isqrt n
  r * r ≤ n := sorry

theorem isqrt_next_exceeds (n : Nat) (h : n > 0) :
  let r := isqrt n 
  (r + 1) * (r + 1) > n := sorry
