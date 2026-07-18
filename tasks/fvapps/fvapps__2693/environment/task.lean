import Mathlib

universe u

variable (α : Type u)

/-- Function signature for remove_nth_element -/
def removeNthElement (arr : List α) (n : Nat) : List α :=
  sorry

/-- Length decreases by 1 after removing element -/
theorem removeNthElement_length_decreases {α : Type u} (arr : List α) (n : Nat) 
    (h : n < arr.length) :
    (removeNthElement α arr n).length = arr.length - 1 :=
  sorry

/-- Elements before n stay unchanged -/
theorem removeNthElement_prefix_unchanged {α : Type u} (arr : List α) (n : Nat)
    (h : n < arr.length) :
    (removeNthElement α arr n).take n = arr.take n :=
  sorry

/-- Elements after n are unchanged but shifted -/
theorem removeNthElement_suffix_shifted {α : Type u} (arr : List α) (n : Nat)
    (h : n < arr.length) :
    (removeNthElement α arr n).drop n = arr.drop (n + 1) :=
  sorry

/-- Removing first element gives tail -/
theorem removeNthElement_zero_is_tail {α : Type u} (arr : List α)
    (h : arr ≠ []) :
    removeNthElement α arr 0 = arr.tail :=
  sorry
