import Mathlib

inductive NestedType where
  | str : String → NestedType
  | int : Int → NestedType 
  | lst : List NestedType → NestedType

def unpack : NestedType → List (String ⊕ Int) := sorry

def isNested : NestedType → Bool := sorry

theorem unpack_flattens_nested : ∀ (x : NestedType),
  let result := unpack x
  -- Result is a list of non-nested values
  result.length > 0 := sorry

theorem unpack_preserves_string : ∀ (s : String),
  unpack (NestedType.str s) = [Sum.inl s] := sorry 

theorem unpack_preserves_list_ints : ∀ (lst : List Int),
  let nested := lst.map NestedType.int
  let result := unpack (NestedType.lst nested)
  -- All elements are preserved and length is preserved
  result.length = lst.length ∧
  ∀ (x : Int), x ∈ lst → Sum.inr x ∈ result := sorry
