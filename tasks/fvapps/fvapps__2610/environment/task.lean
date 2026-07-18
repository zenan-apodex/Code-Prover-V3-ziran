import Mathlib

structure Finset (α : Type) where
  elems : List α
  nodups : elems.Nodup

def List.toFinset {α : Type} (l : List α) : Finset α :=
  sorry

def count_dual_subscribers (eng: List Int) (fr: List Int) : Nat :=
  sorry

theorem count_dual_subscribers_bounded (eng fr: List Int) : 
  count_dual_subscribers eng fr ≤ eng.length ∧ 
  count_dual_subscribers eng fr ≤ fr.length :=
sorry

theorem count_dual_subscribers_nonnegative (eng fr: List Int) :
  count_dual_subscribers eng fr ≥ 0 :=
sorry

def intersection_size {α : Type} (l1 l2 : List α) : Nat :=
  sorry  

theorem count_dual_subscribers_equals_intersection (eng fr: List Int) :
  count_dual_subscribers eng fr = intersection_size eng fr :=
sorry

theorem count_dual_subscribers_symmetric (eng fr: List Int) :
  count_dual_subscribers eng fr = count_dual_subscribers fr eng :=
sorry

theorem count_dual_subscribers_empty_list (eng fr: List Int) :
  count_dual_subscribers [] fr = 0 ∧
  count_dual_subscribers eng [] = 0 :=
sorry

def uniqueCount {α : Type} (l : List α) : Nat :=
  sorry

theorem count_dual_subscribers_same_list (xs: List Int) :
  count_dual_subscribers xs xs = uniqueCount xs :=
sorry
