import Mathlib

def sumOfIntervals (intervals: List (Int × Int)) : Int :=
  sorry

def normalizeInterval (interval: Int × Int) : Int × Int :=
  let (a, b) := interval
  (min a b, max a b)

def normalizeIntervals (intervals: List (Int × Int)) : List (Int × Int) :=
  intervals.map normalizeInterval

theorem sum_of_intervals_non_negative
    (intervals: List (Int × Int)) (h: intervals.length ≥ 1):
    sumOfIntervals (normalizeIntervals intervals) ≥ 0 := sorry

theorem sum_of_intervals_bounded_by_range
    (intervals: List (Int × Int)) (h: intervals.length ≥ 1):
    let normalized := normalizeIntervals intervals
    let minStart := normalized.map Prod.fst |>.minimum?.get!
    let maxEnd := normalized.map Prod.snd |>.maximum?.get!
    sumOfIntervals normalized ≤ maxEnd - minStart := sorry

theorem sum_of_intervals_single_case
    (intervals: List (Int × Int)) 
    (h: intervals.length = 1):
    let normalized := normalizeIntervals intervals
    let (a,b) := normalized.head!
    sumOfIntervals normalized = b - a := sorry

theorem sum_of_intervals_reordering_invariant
    (intervals: List (Int × Int))
    (sorted: List (Int × Int))
    (h: sorted.isPerm (normalizeIntervals intervals)):
    sumOfIntervals (normalizeIntervals intervals) = 
    sumOfIntervals sorted := sorry

def sumLengths (intervals: List (Int × Int)) : Int :=
  let lengths := intervals.map (fun i => i.2 - i.1)
  lengths.foldl (· + ·) 0

theorem sum_of_overlapping_intervals_bounded
    (intervals: List (Int × Int))
    (h: intervals.length ≥ 2):
    let normalized := normalizeIntervals intervals
    sumOfIntervals normalized ≤ sumLengths normalized := sorry
