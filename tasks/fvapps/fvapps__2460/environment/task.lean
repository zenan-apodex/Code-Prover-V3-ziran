import Mathlib

def maxSubArray (nums : List Int) : Int := sorry

def List.sum (l : List Int) : Int := sorry

def List.max (l : List Int) : Int := sorry

theorem maxSubArray_geq_max (nums : List Int) (h: nums ≠ []) :
  maxSubArray nums ≥ List.max nums := sorry

theorem maxSubArray_all_positive (nums : List Int) (h1: nums ≠ []) 
  (h2: ∀ x ∈ nums, x > 0) :
  maxSubArray nums = List.sum nums := sorry

theorem maxSubArray_geq_elements (nums : List Int) (h: nums ≠ []) :
  ∀ x ∈ nums, maxSubArray nums ≥ x := sorry

theorem maxSubArray_exists_subarray (nums : List Int) (h: nums ≠ []) :
  ∃ i j, i ≤ j ∧ j < nums.length ∧ 
    List.sum (List.take (j - i + 1) (List.drop i nums)) = maxSubArray nums := sorry

theorem maxSubArray_binary (nums : List Int) (h1: nums ≠ [])
  (h2: ∀ x ∈ nums, x ≥ -1 ∧ x ≤ 1) :
  maxSubArray nums = List.max nums ∨ maxSubArray nums > 0 := sorry
