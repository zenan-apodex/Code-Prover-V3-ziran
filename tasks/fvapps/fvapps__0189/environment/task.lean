import Mathlib

def unhappyFriends (n: Nat) (preferences: List (List Nat)) (pairs: List (List Nat)) : Nat :=
sorry

theorem unhappyFriends_output_is_nat (n: Nat) (preferences: List (List Nat)) (pairs: List (List Nat)) :
  n % 2 = 0 →
  n ≥ 2 → 
  n ≤ 6 →
  (∀ p ∈ preferences, p.length = n - 1) →
  (∀ p ∈ preferences, ∀ i, i ∈ p → i < n ∧ i ≠ preferences.indexOf p) →
  (∀ p ∈ pairs, p.length = 2) →
  (∀ p ∈ pairs, ∀ i ∈ p, i < n) →
  ∃ result, result = unhappyFriends n preferences pairs ∧ result ≤ n :=
sorry

theorem unhappyFriends_output_nonnegative (n: Nat) (preferences: List (List Nat)) (pairs: List (List Nat)) :
  n % 2 = 0 →
  n ≥ 2 →
  n ≤ 6 →
  (∀ p ∈ preferences, p.length = n - 1) →
  (∀ p ∈ preferences, ∀ i, i ∈ p → i < n ∧ i ≠ preferences.indexOf p) →
  (∀ p ∈ pairs, p.length = 2) →
  (∀ p ∈ pairs, ∀ i ∈ p, i < n) →
  unhappyFriends n preferences pairs ≥ 0 :=
sorry
