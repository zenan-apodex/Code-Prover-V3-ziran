import Mathlib

inductive LinkedList (α : Type)
  | nil : LinkedList α
  | cons : α → LinkedList α → LinkedList α

def list_to_array {α : Type} : LinkedList α → List α
  | _ => sorry

theorem list_to_array_preserves_values {α : Type} (l : LinkedList α) :
  list_to_array l = LinkedList.rec [] (fun head tail arr => head :: arr) l :=
sorry

theorem list_to_array_maintains_order {α : Type} [Inhabited α] (l : LinkedList α) :
  ∀ i < (list_to_array l).length,
    (list_to_array l).get ⟨i, by sorry⟩ = LinkedList.rec default (fun head tail res => head) l :=
sorry

theorem list_to_array_empty {α : Type} :
  list_to_array (@LinkedList.nil α) = @List.nil α :=
sorry
