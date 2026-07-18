import Mathlib

namespace Bucketize

def bucketize : List Int → List (Option (List Int)) := sorry

/-
  The bucketize function returns a list with length equal to one plus
  the length of the input list 
-/
theorem bucketize_length (nums : List Int) : 
  (bucketize nums).length = nums.length + 1 := sorry

/-
  For each non-empty bucket in the output, its elements are sorted
-/
theorem bucketize_sorted (nums : List Int) (i : Nat) (bucket : List Int) :
  (bucketize nums).get? i = some (some bucket) →
  ∀ x y, x ∈ bucket → y ∈ bucket → bucket.indexOf x ≤ bucket.indexOf y → x ≤ y := sorry

/-
  For each number in bucket i, that number appears exactly i times in the input list
-/
theorem bucketize_frequency (nums : List Int) (i : Nat) (bucket : List Int) (n : Int) :
  (bucketize nums).get? i = some (some bucket) → 
  n ∈ bucket →
  (nums.filter (· = n)).length = i := sorry

end Bucketize
