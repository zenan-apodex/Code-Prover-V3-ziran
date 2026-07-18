import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | (x::xs) => x + xs.sum

def find (rats : List Nat) : Nat := sorry

theorem find_total_is_sum_of_powers (rats : List Nat) 
  (h : ∀ x, x ∈ rats → x ≤ 9) 
  (h2 : ∀ x y, x ∈ rats → y ∈ rats → x = y → x = y)
  (h3 : rats.length > 0)
  (h4 : (rats.map (fun r => 2^r)).sum ≤ 1000) :
  find rats = (rats.map (fun r => 2^r)).sum := sorry

theorem find_binary_representation (rats : List Nat)
  (h : ∀ x, x ∈ rats → x ≤ 9)
  (h2 : ∀ x y, x ∈ rats → y ∈ rats → x = y → x = y)
  (h3 : rats.length > 0) :
  ∀ i, i ≤ 9 → 
    (if i ∈ rats 
     then (find rats).mod (2^(i+1)) ≥ 2^i
     else (find rats).mod (2^(i+1)) < 2^i) := sorry

theorem find_commutative (rats : List Nat)
  (h : ∀ x, x ∈ rats → x ≤ 9)
  (h2 : ∀ x y, x ∈ rats → y ∈ rats → x = y → x = y)
  (h3 : rats.length > 0) :
  find rats = find rats.reverse := sorry
