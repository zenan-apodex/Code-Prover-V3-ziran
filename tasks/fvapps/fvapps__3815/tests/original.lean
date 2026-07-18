import Mathlib

def coprimes (n : Nat) : List Nat := sorry

def gcd (a b : Nat) : Nat := sorry

theorem coprimes_all_less (n : Nat) (h : n ≥ 2) :
  ∀ x ∈ coprimes n, x > 0 ∧ x < n := sorry







def countCoprimes (n : Nat) : Nat :=
  (List.range n).filter (fun x => gcd x n = 1) |>.length
