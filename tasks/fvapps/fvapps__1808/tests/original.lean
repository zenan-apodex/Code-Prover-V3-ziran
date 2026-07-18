import Mathlib

def Interval := Int × Int

def eraseOverlapIntervals (intervals : List Interval) : Nat :=
  sorry

theorem eraseOverlapIntervals_output_bounds
  (intervals : List Interval)
  (h : ∀ i ∈ intervals, i.1 ≤ i.2) :
  0 ≤ eraseOverlapIntervals intervals ∧ eraseOverlapIntervals intervals ≤ intervals.length :=
  sorry

theorem eraseOverlapIntervals_empty_list :
  eraseOverlapIntervals [] = 0 :=
  sorry

theorem eraseOverlapIntervals_single_interval
  (i : Interval)
  (h : i.1 ≤ i.2) :
  eraseOverlapIntervals [i] = 0 :=
  sorry
