import Mathlib

def List.sum (l : List Nat) : Nat :=
  l.foldl (· + ·) 0
  
def List.sort (l : List Nat) : List Nat :=
  sorry
  
def List.perm (l1 l2 : List Nat) : Prop :=
  sorry

def List.takeNth (l : List Nat) (n : Nat) : List Nat :=
  sorry

def maxCoins (piles : List Nat) : Nat :=
  sorry









theorem maxcoins_minimal :
  maxCoins [1,1,1] = 1 :=
sorry
