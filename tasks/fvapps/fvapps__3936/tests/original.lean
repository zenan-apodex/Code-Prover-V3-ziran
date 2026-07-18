import Mathlib

def zozonacci (pattern : List String) (n : Nat) : List Nat := sorry

def isNonNegative (l : List Nat) : Prop := 
  ∀ x ∈ l, x ≥ 0

def isMonotonicFrom (l : List Nat) (start : Nat) : Prop :=
  ∀ i v1 v2, start ≤ i → i < l.length - 1 → l[i]? = some v1 → l[i+1]? = some v2 → v1 ≤ v2

theorem empty_pattern_returns_empty (n : Nat) :
  zozonacci [] n = [] := sorry
