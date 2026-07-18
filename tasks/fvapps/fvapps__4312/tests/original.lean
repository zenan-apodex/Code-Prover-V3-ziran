import Mathlib

structure PeakResult where
  pos : List Nat
  peaks : List Int
deriving Repr

def pickPeaks : List Int → PeakResult := sorry

theorem pick_peaks_result_structure (arr : List Int) : 
  let result := pickPeaks arr
  List.length result.pos = List.length result.peaks := sorry

theorem peaks_correspond_to_positions (arr : List Int) :
  let result := pickPeaks arr
  ∀ (i : Nat), i < result.pos.length →
    arr[result.pos[i]!]! = result.peaks[i]! := sorry

theorem positions_are_ordered (arr : List Int) :
  let result := pickPeaks arr
  ∀ i j, i < j → j < result.pos.length → 
    result.pos[i]! < result.pos[j]! := sorry

theorem peaks_higher_than_neighbors (arr : List Int) :
  let result := pickPeaks arr
  ∀ (pos : Nat), pos ∈ result.pos →
    pos > 0 ∧ pos < arr.length - 1 ∧
    arr[pos]! > arr[pos-1]! ∧
    (∃ i, i > pos ∧ i < arr.length ∧
      (∀ j, pos ≤ j ∧ j < i → arr[j]! = arr[pos]!) ∧
      arr[i]! < arr[pos]!) := sorry

theorem plateau_peak_leftmost (arr : List Int) :
  let result := pickPeaks arr
  ∀ (pos : Nat), pos ∈ result.pos →
    ∃ i, i > pos ∧ i < arr.length ∧
    (∀ j, pos ≤ j ∧ j < i → arr[j]! = arr[pos]!) ∧
    arr[i]! < arr[pos]! := sorry
