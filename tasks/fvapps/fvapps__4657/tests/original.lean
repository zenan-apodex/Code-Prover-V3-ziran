import Mathlib

universe u

structure Bag (α : Type u) where
  count : α → Nat

def List.toBag {α : Type u} [BEq α] (l : List α) : Bag α where
  count a := List.length (List.filter (fun x => x == a) l)

def sort_by_perfsq (arr : List Nat) : List Nat := sorry

theorem sort_by_perfsq_maintains_length {arr : List Nat} :
  List.length (sort_by_perfsq arr) = List.length arr := sorry

theorem sort_by_perfsq_maintains_elements {arr : List Nat} :
  (sort_by_perfsq arr).toBag = arr.toBag := sorry

theorem sort_by_perfsq_idempotent {arr : List Nat} :
  sort_by_perfsq (sort_by_perfsq arr) = sort_by_perfsq arr := sorry
