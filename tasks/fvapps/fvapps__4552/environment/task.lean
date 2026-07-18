import Mathlib

def rankings (arr : List Int) : List Nat :=
  sorry

theorem rankings_length {arr : List Int} (h : arr ≠ []) :
  (rankings arr).length = arr.length :=
sorry

theorem rankings_range {arr : List Int} (h : arr ≠ []) :
  let ranks := rankings arr 
  (∀ r ∈ ranks, 1 ≤ r ∧ r ≤ arr.length) ∧ 
  (ranks.length = arr.length) :=
sorry
