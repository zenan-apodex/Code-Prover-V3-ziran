import Mathlib

inductive NestedList (α : Type)
  | elem (x : α) : NestedList α 
  | list (xs : List (NestedList α)) : NestedList α

def flatten {α : Type} (lst : List (NestedList α)) : List α := sorry

theorem flatten_preserves_elements {α : Type} (lst : List (NestedList α)) :
  ∀ x ∈ lst, match x with
  | NestedList.elem v => v ∈ flatten lst
  | NestedList.list xs => ∀ y ∈ xs, match y with 
    | NestedList.elem v => v ∈ flatten lst
    | _ => True := sorry

theorem flatten_removes_one_level {α : Type} (lst : List (NestedList α)) :
  ∀ x ∈ lst, match x with
  | NestedList.list xs => ∀ y ∈ xs, y ≠ NestedList.list []
  | _ => True →
  ∀ z ∈ flatten lst, ∀ w, z ≠ w := sorry

theorem flatten_order_preserved {α : Type} (lst : List (NestedList α)) :
  flatten lst = lst.foldl (λ acc x => 
    match x with
    | NestedList.elem v => acc ++ [v]
    | NestedList.list xs => acc ++ flatten xs
  ) [] := sorry

theorem flatten_identity_flat_list {α : Type} (lst : List α) :
  flatten (lst.map NestedList.elem) = lst := sorry
