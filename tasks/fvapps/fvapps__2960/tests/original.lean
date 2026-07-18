import Mathlib

def sumDifferencesBetweenProductsAndLCMs (pairs : List (Nat × Nat)) : Nat :=
  sorry

def List.sum (l : List Nat) : Nat :=
  match l with
  | [] => 0
  | h :: t => h + List.sum t

theorem empty_list_gives_zero :
  sumDifferencesBetweenProductsAndLCMs [] = 0 :=
sorry

theorem zero_pairs_give_zero (n : Nat) :
  sumDifferencesBetweenProductsAndLCMs (List.replicate n (0, 0)) = 0 :=
sorry

theorem result_leq_sum_products (pairs : List (Nat × Nat)) :
  pairs ≠ [] →
  sumDifferencesBetweenProductsAndLCMs pairs ≤ 
    List.sum (pairs.map (fun p => p.fst * p.snd)) :=
sorry

theorem commutative (pairs : List (Nat × Nat)) :
  sumDifferencesBetweenProductsAndLCMs pairs = 
  sumDifferencesBetweenProductsAndLCMs (pairs.map fun p => (p.snd, p.fst)) :=
sorry
