import Mathlib

def string_hash (s : String) : Int :=
  sorry

theorem string_hash_returns_integer (s : String) (h : s.length > 0) :
  ∃ n : Int, string_hash s = n :=
  sorry

theorem string_hash_deterministic (s : String) (h : s.length > 1) :
  string_hash s = string_hash s :=
  sorry

theorem string_hash_space_sensitive (s : String) (h : s.length > 0) :
  string_hash s ≠ string_hash (s ++ " ") ∧
  string_hash (s ++ " ") = string_hash (s ++ " ") :=
  sorry

theorem string_hash_specific_value : 
  string_hash "a" = 64 :=
  sorry
