import Mathlib

def solve_abc_strings (s : String) : Nat :=
  sorry

theorem output_range (s : String) 
  (h : ∀ c ∈ s.data, c = 'a' ∨ c = 'b' ∨ c = 'c') 
  (h2 : s ≠ "") : 
  let result := solve_abc_strings s
  0 ≤ result ∧ result < 998244353 := sorry

theorem single_char_repeated (n : Nat) (c : Char)
  (h : c = 'a' ∨ c = 'b' ∨ c = 'c')
  (h2 : n > 0) :
  solve_abc_strings (String.mk (List.replicate n c)) = 1 := sorry

theorem alternating_pattern (n : Nat)
  (h : n > 0) :
  solve_abc_strings (String.mk (List.join (List.replicate n ['a', 'b']))) ≠ 1 ∧
  solve_abc_strings (String.mk (List.join (List.replicate n ['b', 'c']))) ≠ 1 ∧ 
  solve_abc_strings (String.mk (List.join (List.replicate n ['a', 'c']))) ≠ 1 := sorry

theorem empty_string :
  solve_abc_strings "" = 0 := sorry

theorem single_char (c : Char)
  (h : c = 'a' ∨ c = 'b' ∨ c = 'c') :
  solve_abc_strings (String.mk [c]) = 1 := sorry

theorem valid_chars (s : String) :
  ∀ c ∈ s.data, c = 'a' ∨ c = 'b' ∨ c = 'c' := sorry
