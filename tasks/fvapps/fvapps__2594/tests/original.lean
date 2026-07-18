import Mathlib

structure WordCountResult where
  uniqueCount : Nat
  occurrences : List Nat
deriving Repr

def List.sum : List Nat → Nat
  | [] => 0
  | (h::t) => h + sum t

def count_word_occurrences (words : List String) : WordCountResult :=
  sorry

theorem count_word_occurrences_empty_input :
  count_word_occurrences [] = ⟨0, []⟩ :=
sorry
