import Mathlib

def maxArea (heights : List Nat) : Nat := sorry

theorem maxArea_nonnegative (heights : List Nat) :
  heights.length ≥ 2 → maxArea heights ≥ 0 := sorry

theorem maxArea_upper_bound (heights : List Nat) :
  heights.length ≥ 2 → 
  maxArea heights ≤ (List.maximum? heights).getD 0 * (heights.length - 1) := sorry

theorem maxArea_is_maximum (heights : List Nat) (i j : Nat) (hi : i < heights.length) (hj : j < heights.length) :
  heights.length ≥ 2 →
  i < j →
  maxArea heights ≥ min (heights.get ⟨i, hi⟩) (heights.get ⟨j, hj⟩) * (j - i) := sorry

theorem maxArea_symmetric (heights : List Nat) :
  heights.length ≥ 2 →
  maxArea heights = maxArea heights.reverse := sorry

theorem maxArea_uniform (value length : Nat) : 
  length ≥ 2 →
  maxArea (List.replicate length value) = value * (length - 1) := sorry

theorem maxArea_interpolation (heights : List Nat) :
  heights.length ≥ 2 →
  let interpolated := heights.take 1 ++ List.replicate (heights.length - 2) 0 ++ heights.drop (heights.length - 1)
  maxArea heights ≥ maxArea interpolated := sorry
