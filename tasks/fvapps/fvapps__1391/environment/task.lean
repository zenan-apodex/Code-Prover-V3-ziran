import Mathlib

structure Cell where
  start : Nat
  finish : Nat
  capacity : Nat
  deriving Repr

def maxRestaurantCustomers (testCases : List (List Cell)) : List Nat :=
  sorry

theorem max_customers_single_case
  (n k : Nat)
  (cells : List Cell)
  (h1 : n ≥ 1)
  (h2 : k ≥ 1) 
  (h3 : cells.length ≥ 1)
  (h4 : ∀ c ∈ cells, c.start < c.finish)
  (h5 : ∀ c ∈ cells, c.capacity ≤ k) :
  let result := maxRestaurantCustomers [cells]
  result.head! ≤ cells.length ∧ 
  result.head! ≤ k * n :=
sorry

theorem max_customers_multiple_cases
  (testCases : List (List Cell))
  (h1 : testCases.length ≥ 1)
  (h2 : ∀ case ∈ testCases, case.length ≥ 1)
  (h3 : ∀ case ∈ testCases, ∀ c ∈ case, c.start < c.finish)
  (h4 : ∀ case ∈ testCases, ∀ c ∈ case, c.capacity ≤ k) :
  let results := maxRestaurantCustomers testCases
  results.length = testCases.length ∧
  ∀ i < results.length, 
    results[i]! ≤ testCases[i]!.length ∧
    results[i]! ≤ k * n :=
sorry
