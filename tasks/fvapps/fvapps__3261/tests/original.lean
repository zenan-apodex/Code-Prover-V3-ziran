import Mathlib

inductive Suit where
  | Spades | Diamonds | Hearts | Clubs

inductive Rank where
  | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten
  | Jack | Queen | King | Ace

def sort_poker (john: String) (uncle: String) : String :=
  sorry

theorem sort_poker_idempotent 
  (john: String) (uncle: String) :
  uncle = "S2D2H2C2" →
  sort_poker (sort_poker john uncle) uncle = sort_poker john uncle :=
sorry
