import Mathlib

variable {α : Type} [DecidableEq α]

def count (xs : List α) (a : α) : Nat :=
  xs.foldl (fun acc x => if x = a then acc + 1 else acc) 0

def majority : List α → Option α := sorry

theorem majority_exists {arr : List α} {x : α}
  (h : count arr x > arr.length / 2) :
  majority arr = some x := sorry

theorem majority_empty :
  majority ([] : List α) = none := sorry

theorem majority_single_element {arr : List α} {x : α}
  (h_nonempty : arr ≠ [])
  (h_all_same : ∀ i, arr.get ⟨i, sorry⟩ = x) :
  majority arr = some x := sorry
