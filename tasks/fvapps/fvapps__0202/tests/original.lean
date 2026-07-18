import Mathlib

def longestMountain (arr : Array Int) : Nat :=
  sorry

def isSorted (arr : Array Int) : Bool :=
  sorry

theorem mountain_length_min_or_zero {arr : Array Int} :
  let result := longestMountain arr
  result = 0 ∨ result ≥ 3
  := sorry

theorem mountain_length_bounded {arr : Array Int} :
  longestMountain arr ≤ arr.size
  := sorry

theorem flat_sequence_no_mountain {arr : Array Int} :
  let doubled := arr.concatMap (fun x => #[x, x]) 
  longestMountain doubled = 0
  := sorry



theorem single_element_no_mountain {x : Int} :
  longestMountain #[x] = 0
  := sorry
