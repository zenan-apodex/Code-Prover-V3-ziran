import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | (x::xs) => x + xs.sum

def List.maximum : List Nat → Nat
  | [] => 0
  | [x] => x 
  | (x::xs) => max x (xs.maximum)

def solve_candy_sharing (n : Nat) (arr : List Nat) : Nat :=
  sorry

theorem solve_candy_sharing_bounds 
  {n : Nat} {arr : List Nat}
  (h1 : n > 0)
  (h2 : arr.length = n)
  (h3 : ∀ x ∈ arr, x > 0 ∧ x ≤ 1000)
  : solve_candy_sharing n arr ≥ (arr.sum + n - 1) / n ∧ 
    solve_candy_sharing n arr ≤ arr.maximum :=
  sorry

theorem solve_candy_sharing_single
  (n : Nat)
  (h1 : n > 0)
  (h2 : n ≤ 100)
  : solve_candy_sharing 1 [n] = n :=
  sorry

theorem solve_candy_sharing_multiple_elements
  {n : Nat} {arr : List Nat}
  (h1 : arr.length = n)
  (h2 : n ≥ 2)
  (h3 : ∀ x ∈ arr, x > 0 ∧ x ≤ 1000)
  : solve_candy_sharing n arr > 0 :=
  sorry
