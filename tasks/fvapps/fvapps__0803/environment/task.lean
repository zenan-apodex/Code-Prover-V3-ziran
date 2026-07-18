import Mathlib

inductive Suit where
  | Hearts
  | Diamonds
  | Spades 
  | Clubs
  deriving BEq, Repr

inductive Rank where
  | Ace
  | Two 
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight  
  | Nine
  | Ten
  | Jack
  | Queen
  | King
  deriving BEq, Repr

def Rank.toNat : Rank → Nat 
  | Ace => 14
  | Two => 2
  | Three => 3
  | Four => 4
  | Five => 5
  | Six => 6
  | Seven => 7
  | Eight => 8
  | Nine => 9
  | Ten => 10
  | Jack => 11
  | Queen => 12
  | King => 13

inductive HandResult where
  | RoyalFlush
  | StraightFlush
  | FourOfAKind
  | FullHouse
  | Flush
  | Straight
  | ThreeOfAKind
  | TwoPairs
  | Pair
  | HighCard
  deriving BEq, Repr

structure Card where
  rank : Rank
  suit : Suit
  deriving BEq

abbrev Hand := List Card

def evaluate_poker_hand (h : Hand) : HandResult := 
  sorry

theorem evaluate_poker_hand_returns_valid_result (h : Hand) 
  (h5 : h.length = 5) (hunique : h.Nodup) :
  ∃ (result : HandResult), evaluate_poker_hand h = result :=
sorry

theorem royal_flush_requires_specific_cards (h : Hand)
  (h5 : h.length = 5) (hunique : h.Nodup) :
  evaluate_poker_hand h = HandResult.RoyalFlush →
  (∃ (s : Suit), ∀ (c : Card), c ∈ h → c.suit = s) ∧
  h.map Card.rank = [Rank.Ace, Rank.King, Rank.Queen, Rank.Jack, Rank.Ten] :=
sorry

theorem straight_consecutive_ranks (h : Hand)
  (h5 : h.length = 5) (hunique : h.Nodup) :
  evaluate_poker_hand h = HandResult.Straight ∨ 
  evaluate_poker_hand h = HandResult.StraightFlush →
  let ranks := (h.map Card.rank).map Rank.toNat
  ∃ (min : Nat), ranks = [min, min+1, min+2, min+3, min+4] ∨ 
                 ranks = [14, 2, 3, 4, 5] :=
sorry

theorem flush_same_suit (h : Hand)
  (h5 : h.length = 5) (hunique : h.Nodup) :
  evaluate_poker_hand h = HandResult.Flush ∨ 
  evaluate_poker_hand h = HandResult.StraightFlush ∨
  evaluate_poker_hand h = HandResult.RoyalFlush →
  ∃ (s : Suit), ∀ (c : Card), c ∈ h → c.suit = s :=
sorry

theorem four_of_kind_has_four_same_rank (h : Hand)
  (h5 : h.length = 5) (hunique : h.Nodup) :
  evaluate_poker_hand h = HandResult.FourOfAKind →
  ∃ r : Rank, (h.filter (fun c ↦ c.rank == r)).length = 4 :=
sorry

theorem three_of_kind_has_three_same_rank (h : Hand)
  (h5 : h.length = 5) (hunique : h.Nodup) :
  evaluate_poker_hand h = HandResult.ThreeOfAKind →
  ∃ r : Rank, (h.filter (fun c ↦ c.rank == r)).length = 3 ∧
  ¬∃ r : Rank, (h.filter (fun c ↦ c.rank == r)).length = 2 :=
sorry

theorem two_pairs_has_two_pairs (h : Hand)
  (h5 : h.length = 5) (hunique : h.Nodup) :
  evaluate_poker_hand h = HandResult.TwoPairs →
  ∃ r1 r2 : Rank, r1 ≠ r2 ∧
  (h.filter (fun c ↦ c.rank == r1)).length = 2 ∧
  (h.filter (fun c ↦ c.rank == r2)).length = 2 :=
sorry
