import Mathlib

structure Dict where
  items : List (String × Int)

def sort_dict (d : Dict) : List (String × Int) := sorry

theorem sort_dict_preserves_items (d : Dict) :
  Dict.mk (sort_dict d) = d := sorry

theorem sort_dict_ordering (d : Dict) (h : (d.items).length ≥ 2) :
  ∀ i : Nat, i < (sort_dict d).length - 1 →
    ((sort_dict d).get! i).2 ≥ ((sort_dict d).get! (i+1)).2 := sorry

theorem sort_dict_length (d : Dict) :
  (sort_dict d).length = d.items.length := sorry

theorem sort_dict_returns_tuples (d : Dict) :
  ∀ x ∈ sort_dict d, ∃ s : String, ∃ n : Int, x = (s, n) := sorry
