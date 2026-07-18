import Mathlib

universe u

def isValidTriplet (arr : List Int) (i j k a b c : Nat) : Bool :=
  sorry

def countTripletsBruteforce (arr : List Int) (a b c : Nat) : Nat :=
  sorry

def countGoodTriplets (arr : List Int) (a b c : Nat) : Nat :=
  sorry

theorem countGoodTriplets_matches_bruteforce 
    (arr : List Int) (a b c : Nat) 
    (h : arr.length ≥ 3)
    (h2 : arr.length ≤ 20)
    (h3 : ∀ x ∈ arr, -100 ≤ x ∧ x ≤ 100)
    (h4 : a ≤ 50 ∧ b ≤ 50 ∧ c ≤ 50) :
    countGoodTriplets arr a b c = countTripletsBruteforce arr a b c :=
  sorry

theorem countGoodTriplets_nonnegative
    (arr : List Int) (a b c : Nat)
    (h : arr.length ≥ 3)
    (h2 : arr.length ≤ 20) :
    0 ≤ countGoodTriplets arr a b c :=
  sorry
