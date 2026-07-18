import Mathlib

def process_text (lines : List String) : List String :=
  sorry

inductive List.LocalSorted : List String → Prop where
  | nil : List.LocalSorted []
  | single (x : String) : List.LocalSorted [x]
  | cons (x y : String) (rest : List String) 
    (h₁ : x ≤ y) (h₂ : List.LocalSorted (y::rest)) : 
    List.LocalSorted (x::y::rest)

inductive List.LocalNodup : List α → Prop where
  | nil : List.LocalNodup []
  | cons (x : α) (xs : List α) 
    (h₁ : x ∉ xs) (h₂ : List.LocalNodup xs) : 
    List.LocalNodup (x::xs)

theorem process_text_output_properties {lines : List String} :
  let result := process_text lines
  -- First element is length of remaining list
  (result.head! = toString (result.tail.length)) ∧ 
  -- Result is sorted
  result.tail.LocalSorted ∧
  -- All elements are lowercase
  (∀ x ∈ result.tail, x = x.toLower) ∧
  -- No duplicates
  result.tail.LocalNodup :=
  sorry

theorem process_text_empty_strings {lines : List String} :
  (∀ x ∈ lines, x = "") → 
  process_text lines = ["0"] :=
  sorry

def words (s : String) : List String :=
  sorry

theorem process_text_case_insensitive_count {lines : List String} 
  (h₁ : ∀ x ∈ lines, x.length > 0)
  (h₂ : ∀ x ∈ lines, ∀ c ∈ x.toList, c.isAlpha ∨ c = ' ') :
  let lines_with_upper := lines ++ (lines.map String.toUpper)
  let result := process_text lines_with_upper
  let original_words := (lines.bind (λ s => words s)).map String.toLower |>.eraseDups
  result.tail.length = original_words.length :=
  sorry
