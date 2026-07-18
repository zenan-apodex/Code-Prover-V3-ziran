import Mathlib

def sum_mix (arr : List (String ⊕ Int)) : Int :=
  sorry

def List.sum (xs : List Int) : Int :=
  sorry

def List.perm {α : Type} (xs ys : List α) : Prop :=
  sorry

theorem sum_mix_equals_int_conversion {arr : List (String ⊕ Int)} :
  sum_mix arr = arr.foldl (fun acc x => acc + match x with 
                                            | Sum.inl s => s.toInt!
                                            | Sum.inr n => n) 0 := by
  sorry

theorem sum_mix_order_independent {arr₁ arr₂ : List (String ⊕ Int)} :
  List.perm arr₁ arr₂ → sum_mix arr₁ = sum_mix arr₂ := by
  sorry

theorem sum_mix_all_ints {arr : List Int} :
  sum_mix (arr.map Sum.inr) = List.sum arr := by
  sorry

theorem sum_mix_all_strings {arr : List String} :
  sum_mix (arr.map Sum.inl) = List.sum (arr.map String.toInt!) := by
  sorry
