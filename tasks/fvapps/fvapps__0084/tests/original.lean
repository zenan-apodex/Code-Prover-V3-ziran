import Mathlib

def solve_stack_exterminable (arr : List Int) : Nat :=
  sorry

theorem solve_stack_exterminable_nonnegative 
  (arr : List Int) 
  (h : ∀ x ∈ arr, 1 ≤ x ∧ x ≤ 100) 
  (h2 : arr ≠ []) : 
  0 ≤ solve_stack_exterminable arr :=
  sorry

theorem solve_stack_exterminable_reverse_equals_forward
  (arr : List Int)
  (h : ∀ x ∈ arr, 1 ≤ x ∧ x ≤ 100)
  (h2 : arr ≠ []) :
  solve_stack_exterminable arr = solve_stack_exterminable arr.reverse :=
  sorry

theorem solve_stack_exterminable_pair_elements
  (arr : List Int)
  (h : ∀ x ∈ arr, 1 ≤ x ∧ x ≤ 100) 
  (h2 : arr.length ≥ 2) :
  let doubled := arr.bind (fun x => [x, x])
  solve_stack_exterminable doubled ≥ arr.length :=
  sorry
