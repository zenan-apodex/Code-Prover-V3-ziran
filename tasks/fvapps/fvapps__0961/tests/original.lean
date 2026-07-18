import Mathlib

inductive Sorted (α : Type) : List α → (α → α → Prop) → Prop where
  | nil : Sorted α [] r
  | single : (a : α) → Sorted α [a] r
  | cons : (a : α) → (as : List α) → (h : Sorted α as r) → 
          (h2 : ∀ x ∈ as, r a x) → Sorted α (a::as) r

def countInversions (arr : List Int) : Nat := sorry

theorem empty_or_single_zero {arr : List Int} :
  arr.length ≤ 1 → countInversions arr = 0 := sorry

theorem sorted_zero {arr : List Int} (h : Sorted Int arr (. ≤ .)) :
  countInversions arr = 0 := sorry

theorem count_nonnegative {arr : List Int} :
  countInversions arr ≥ 0 := sorry

theorem count_bounded {arr : List Int} :
  countInversions arr ≤ (arr.length * (arr.length - 1)) / 2 := sorry

theorem increasing_zero {arr : List Int} (h : Sorted Int arr (. < .)) :
  countInversions arr = 0 := sorry

theorem decreasing_triangular {arr : List Int} (h : Sorted Int arr (fun x y => y < x)) :
  let n := arr.length - 1
  countInversions arr = (n * (n + 1)) / 2 := sorry
