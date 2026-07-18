import Mathlib

inductive Person where
  | mk (name : String) (gender : String) (children : List Person)
deriving Repr, Inhabited

instance : ToString Person where
  toString p := match p with
    | Person.mk name _ _ => name

def Set (α : Type) := α → Prop

def find_seventh_sons_of_seventh_sons (json : String) : Set String :=
  sorry

def fromJson? (s : String) : Option Person :=
  sorry 

def collectNames (p : Person) : Set String :=
  sorry

/- Theorems about find_seventh_sons_of_seventh_sons -/

theorem empty_tree (p : Person) (h : match p with | Person.mk _ _ children => children = []) :
  find_seventh_sons_of_seventh_sons (toString p) = λ _ => False :=
sorry

theorem result_is_subset (json : String) (tree : Person) (h : fromJson? json = some tree) :
  let result := find_seventh_sons_of_seventh_sons json
  let names := collectNames tree
  ∀ x, result x → names x :=
sorry

theorem leaf_nodes (name : String) (p : Person) 
  (h₁ : match p with | Person.mk n _ _ => n = name)
  (h₂ : match p with | Person.mk _ g _ => g = "male") 
  (h₃ : match p with | Person.mk _ _ c => c = []) :
  find_seventh_sons_of_seventh_sons (toString p) = λ _ => False :=
sorry

theorem seventh_son_pattern (root father seventhSon seventhGrandson : Person)
  (h₁ : match father with | Person.mk _ g _ => g = "male")
  (h₂ : match father with | Person.mk _ _ c => List.length c = 7) 
  (h₃ : ∃ children, match father with | Person.mk _ _ c => c = children ∧ children.get? 6 = some seventhSon)
  (h₄ : match seventhSon with | Person.mk _ g _ => g = "male")
  (h₅ : match seventhSon with | Person.mk _ _ c => List.length c = 7)
  (h₆ : ∃ children, match seventhSon with | Person.mk _ _ c => c = children ∧ children.get? 6 = some seventhGrandson)
  (h₇ : match seventhGrandson with | Person.mk n _ _ => n = "grandson7") :
  (find_seventh_sons_of_seventh_sons (toString root)) "grandson7" :=
sorry
