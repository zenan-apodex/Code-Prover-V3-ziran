import Mathlib

structure Matrix where
  data : List (List Nat)
  all_rows_same_length : ∀ row ∈ data, row.length = data.length
  entries_zero_or_one : ∀ i j, i < data.length → j < data.length → 
    data[i]!.get! j ≤ 1
  symmetric : ∀ i j, i < data.length → j < data.length → 
    data[i]!.get! j = data[j]!.get! i
  diagonal_ones : ∀ i, i < data.length → data[i]!.get! i = 1

def find_circle_num (M : Matrix) : Nat :=
  sorry

theorem isolated_students {n : Nat} (h : n > 0) :
  let M : Matrix := { 
    data := List.replicate n (List.replicate n 0)
    all_rows_same_length := sorry
    entries_zero_or_one := sorry
    symmetric := sorry
    diagonal_ones := sorry
  }
  find_circle_num M = n :=
  sorry

theorem fully_connected {n : Nat} (h : n > 0) :
  let M : Matrix := { 
    data := List.replicate n (List.replicate n 1)
    all_rows_same_length := sorry
    entries_zero_or_one := sorry
    symmetric := sorry
    diagonal_ones := sorry
  }
  find_circle_num M = 1 :=
  sorry

theorem circles_bound (M : Matrix) (h : M.data.length = 3) :
  1 ≤ find_circle_num M ∧ find_circle_num M ≤ M.data.length :=
  sorry

theorem two_by_two_circles (M : Matrix) (h : M.data.length = 2) :
  find_circle_num M = 1 ∨ find_circle_num M = 2 :=
  sorry
