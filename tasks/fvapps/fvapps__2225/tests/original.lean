import Mathlib

inductive Result where
  | Alice
  | Bob
  deriving Inhabited, DecidableEq

structure PrefixFreeGame where
  N : Nat
  L : Nat
  strings : List String
  h_nonempty : strings ≠ [] -- non-empty list
  h_prefix_free : ∀ i j, i ≠ j → 
    ¬(List.get! strings i).isPrefixOf (List.get! strings j)
  h_binary : ∀ s ∈ strings, ∀ c ∈ s.data, c = '0' ∨ c = '1'
  h_length : ∀ s ∈ strings, s.length ≤ L
  h_size : strings.length = N

def solve_prefix_free_game (g : PrefixFreeGame) : Result :=
  sorry

def grundy (n : Nat) : Nat :=
  sorry

theorem grundy_positive (n : Nat) : 
  0 < grundy n :=
sorry
