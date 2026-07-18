import Mathlib

def unique (α : Type) [BEq α] : List α → List α := sorry

theorem unique_order (α : Type) [BEq α] (l : List α) :
  let r := unique α l
  (∀ x ∈ r, x ∈ l) ∧ 
  (List.Nodup r) ∧
  (∀ x y, List.indexOf r x < List.indexOf r y → List.indexOf l x < List.indexOf l y) :=
sorry

theorem unique_properties (α : Type) [BEq α] (l : List α) :
  let r := unique α l
  (∀ x ∈ r, x ∈ l) ∧ 
  (∀ x ∈ l, (x ∈ r)) ∧ 
  (r.length ≤ l.length) :=
sorry 

theorem unique_empty (α : Type) [BEq α] : unique α [] = [] := sorry
