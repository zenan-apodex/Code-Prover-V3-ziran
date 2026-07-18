import Mathlib

inductive NestedList (α : Type)
  | elem : α → NestedList α
  | list : List (NestedList α) → NestedList α

def NestedList.depth {α : Type} : NestedList α → Nat
  | elem _ => sorry
  | list _ => sorry

theorem flat_list_depth {α : Type} (l : List α) : 
  NestedList.depth (NestedList.list (l.map NestedList.elem)) = 1 := sorry

theorem list_depth_lower_bound {α : Type} (nl : NestedList α) :
  NestedList.depth nl ≥ 1 := sorry

theorem nested_list_depth_greater {α : Type} (outer : NestedList α) (inner : NestedList α)
  (h : inner ≠ outer) : 
  NestedList.depth outer > NestedList.depth inner := sorry
