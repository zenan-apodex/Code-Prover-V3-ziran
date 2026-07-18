import Mathlib

inductive Node (α : Type)
  | nil : Node α
  | cons : α → Node α → Node α

def stringify {α : Type} [ToString α] : Node α → String :=
  sorry

def make_linked_list {α : Type} : List α → Node α :=
  sorry

def splitOnStr (s : String) (sep : String) : List String :=
  sorry

theorem stringify_matches_list_structure {α : Type} [ToString α] (items : List α) :
  let ll := make_linked_list items
  let result := stringify ll
  let parts := splitOnStr result " -> "
  if items.isEmpty then
    result = "None"
  else
    parts.getLast! = "None" ∧
    parts.length - 1 = items.length ∧
    parts.take items.length = items.map ToString.toString :=
  sorry

theorem stringify_outputs_well_formed {α : Type} [ToString α] (items : List α) :
  let ll := make_linked_list items
  let result := stringify ll
  let parts := splitOnStr result " -> "
  result.endsWith "None" ∧
  parts.all (·.trim ≠ "") ∧
  (if items.isEmpty then
    parts.length = 1
  else
    parts.length = items.length + 1) :=
  sorry
