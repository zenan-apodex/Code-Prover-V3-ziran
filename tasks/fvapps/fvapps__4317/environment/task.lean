import Mathlib

inductive Card where
  | regular : String → String → Card
  | joker : Card

def card_game : Card → Card → String → String := sorry

theorem identical_cards_cheating
  (card1 card2 : Card) (trump : String) :
  card1 = card2 → card_game card1 card2 trump = "Someone cheats." := sorry

theorem joker_always_wins_first
  (card1 card2 : Card) (trump : String) :
  card1 = Card.joker → card2 ≠ Card.joker →
  card_game card1 card2 trump = "The first card won." := sorry

theorem joker_always_wins_second
  (card1 card2 : Card) (trump : String) :
  card2 = Card.joker → card1 ≠ Card.joker →
  card_game card1 card2 trump = "The second card won." := sorry

def card_values := ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

axiom card_value_index : String → Nat

axiom card_value_index_valid :
  ∀ s₁ s₂, s₁ ≠ s₂ → card_value_index s₁ ≠ card_value_index s₂

theorem same_suit_comparison
  (val1 val2 suit trump : String) :
  val1 ≠ val2 →
  let card1 := Card.regular val1 suit
  let card2 := Card.regular val2 suit
  card_value_index val2 > card_value_index val1 →
  card_game card1 card2 trump = "The second card won." := sorry

theorem same_suit_comparison_first_wins
  (val1 val2 suit trump : String) :
  val1 ≠ val2 →
  let card1 := Card.regular val1 suit
  let card2 := Card.regular val2 suit
  card_value_index val1 > card_value_index val2 →
  card_game card1 card2 trump = "The first card won." := sorry

theorem trump_wins_first
  (val1 val2 suit1 suit2 trump : String) :
  suit1 ≠ suit2 →
  suit1 = trump →
  let card1 := Card.regular val1 suit1
  let card2 := Card.regular val2 suit2
  card_game card1 card2 trump = "The first card won." := sorry

theorem trump_wins_second
  (val1 val2 suit1 suit2 trump : String) :
  suit1 ≠ suit2 →
  suit2 = trump →
  let card1 := Card.regular val1 suit1
  let card2 := Card.regular val2 suit2
  card_game card1 card2 trump = "The second card won." := sorry

theorem no_trump_rematch
  (val1 val2 suit1 suit2 trump : String) :
  suit1 ≠ suit2 →
  suit1 ≠ trump →
  suit2 ≠ trump →
  let card1 := Card.regular val1 suit1
  let card2 := Card.regular val2 suit2
  card_game card1 card2 trump = "Let us play again." := sorry
