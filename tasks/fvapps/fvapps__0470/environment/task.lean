import Mathlib

def threeSumMulti (arr : List Nat) (target : Nat) : Nat := sorry

def MOD := 1000000007

def List.sum : List Nat → Nat 
  | [] => 0
  | x::xs => x + List.sum xs

theorem output_range (arr : List Nat) (target : Nat)
  (h1 : arr.length ≥ 1)
  (h2 : arr.length ≤ 3000)
  (h3 : ∀ x ∈ arr, x ≤ 100)
  (h4 : target ≤ 300) :
  threeSumMulti arr target < MOD := sorry

theorem zero_target (arr : List Nat)
  (h1 : arr.length ≥ 1)
  (h2 : arr.length ≤ 3000)
  (h3 : ∀ x ∈ arr, x ≤ 100)
  (h4 : arr.length ≥ 3) :
  threeSumMulti (List.replicate arr.length 0) 0 > 0 := sorry

theorem identical_elements (arr : List Nat) (target : Nat)
  (h1 : arr.length ≥ 3)
  (h2 : arr.length ≤ 3000)
  (h3 : target % 3 = 0)
  (h4 : target / 3 ≤ 100) :
  threeSumMulti (List.replicate arr.length (target / 3)) target > 0 := sorry

theorem small_arrays (arr : List Nat)
  (h1 : arr.length = 3)
  (h2 : ∀ x ∈ arr, x ≤ 100) :
  threeSumMulti arr (List.sum arr) ≥ 1 := sorry

theorem order_independence (arr arr' : List Nat) (target : Nat)
  (h1 : arr.length ≥ 1)
  (h2 : arr.length ≤ 3000)
  (h3 : ∀ x ∈ arr, x ≤ 100)
  (h4 : target ≤ 300)
  (h5 : arr.length = arr'.length)
  (h6 : ∀ n, (arr.count n) = (arr'.count n)) :
  threeSumMulti arr target = threeSumMulti arr' target := sorry
