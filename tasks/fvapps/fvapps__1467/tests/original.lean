import Mathlib

structure Hint where
  op : Char
  num : Nat
  truth : Bool

def guessing_game (hints : List Hint) : Nat :=
  sorry

theorem lies_bounds {hints : List Hint} : 
  let lies := guessing_game hints
  0 ≤ lies ∧ lies ≤ hints.length := by
  sorry

theorem single_hint_result {hint : Hint} :
  let lies := guessing_game [hint]
  lies = 0 ∨ lies = 1 := by
  sorry

theorem contradictory_equal_hints {n m : Nat} (h : n ≠ m) :
  let hints := [⟨'=', n, true⟩, ⟨'=', m, true⟩]
  guessing_game hints = 1 := by
  sorry

theorem opposite_operators_same_number {n : Nat} :
  let hints := [⟨'>', n, true⟩, ⟨'<', n, true⟩]
  guessing_game hints = 1 := by
  sorry

theorem equal_consistency {n : Nat} :
  let hints := [⟨'=', n, true⟩, ⟨'=', n, true⟩]
  guessing_game hints = 0 := by
  sorry
