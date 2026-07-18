import Mathlib

def List.size {α} : List α → Nat 
  | [] => 0
  | (_::xs) => 1 + xs.size

def computeProduct {α} (xs : List α) (ys : List β) : List (α × β) :=
  sorry

theorem computeProduct_matches_itertools {α} (xs : List α) (ys : List β) 
  (h1 : xs.size > 0) (h2 : xs.size ≤ 10)
  (h3 : ys.size > 0) (h4 : ys.size ≤ 10) :
  computeProduct xs ys = List.join (xs.map (λ x => ys.map (λ y => (x, y)))) :=
sorry
