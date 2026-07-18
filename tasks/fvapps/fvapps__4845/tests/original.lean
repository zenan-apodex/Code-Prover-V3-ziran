import Mathlib

structure IsSorted (l: List Int) : Prop where
  sorted : ∀ i j, i < j → j < l.length → l[i]! ≤ l[j]!

def List.isSameStructure : List α → List α → Bool
  | [], [] => true 
  | _::xs, _::ys => isSameStructure xs ys
  | _, _ => false

def getAllNumbers : List (List (List Int)) → List Int
| [] => []
| (x::xs) => getAllNumbers' x ++ getAllNumbers xs
where getAllNumbers' : List (List Int) → List Int
  | [] => []
  | (y::ys) => y ++ getAllNumbers' ys

def sortNestedNumbers (nested: List (List (List Int))) : List (List (List Int)) :=
  sorry

theorem sort_nested_preserves_structure (nested: List (List (List Int))) :
  List.isSameStructure nested (sortNestedNumbers nested) := sorry

theorem sort_nested_preserves_numbers (nested: List (List (List Int))) :
  ∀ x, (x ∈ getAllNumbers nested ↔ x ∈ getAllNumbers (sortNestedNumbers nested)) := sorry

theorem sort_nested_inner_sorted (nested: List (List (List Int))) :
  ∀ middle inner, middle ∈ sortNestedNumbers nested → 
    inner ∈ middle → IsSorted inner := sorry

theorem sort_nested_globally_sorted (nested: List (List (List Int))) :
  IsSorted (getAllNumbers (sortNestedNumbers nested)) := sorry

theorem sort_nested_preserves_length (nested: List (List (List Int))) 
  (h1: List.length nested = n)
  (h2: ∀ middle ∈ nested, List.length middle = m)
  (h3: ∀ middle ∈ nested, ∀ inner ∈ middle, List.length inner = k) :
  (List.length (sortNestedNumbers nested) = n) ∧
  (∀ middle ∈ sortNestedNumbers nested, List.length middle = m) ∧
  (∀ middle ∈ sortNestedNumbers nested, ∀ inner ∈ middle, List.length inner = k) := sorry
