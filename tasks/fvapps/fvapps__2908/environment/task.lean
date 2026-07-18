import Mathlib

structure Dict (α β : Type) where
  get : α → Option β

def flatten {α : Type} [ToString α] (d : Dict α (Dict α String)) : Dict α String :=
  sorry

def appendPath (s1 s2 : String) : String :=
  s1 ++ "/" ++ s2

structure isFlat (d : Dict String String) : Prop where
  flat : ∀ k v, d.get k = some v → ¬∃ k' v', k = appendPath k' v'

theorem flatten_flat_dict_unchanged {d : Dict String String} :
  isFlat d → d = Dict.mk (λ s => d.get s) :=
  sorry

theorem flatten_nested_dict (d : Dict String (Dict String String))
    (outer inner : String) (value : String) :
  (d.get outer >>= (λ innerDict => innerDict.get inner)) = some value →
  (flatten d).get (appendPath outer inner) = some value :=
  sorry

theorem flatten_empty_dict :
  flatten (Dict.mk (λ (_ : String) => none)) = Dict.mk (λ (_ : String) => none) :=
  sorry

theorem flatten_empty_nested_dict :
  flatten (Dict.mk (λ s => if s = "key" 
    then some (Dict.mk (λ (_ : String) => none)) 
    else none)) =
  Dict.mk (λ s => if s = "key" then some "" else none) :=
  sorry
