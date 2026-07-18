import Mathlib

inductive RatPair where
  | forward : RatPair
  | backward : RatPair
deriving Repr

def Town := String
def countDeafRats (t : Town) : Nat :=
  sorry

theorem non_negative_count : ∀ (t : Town),
  countDeafRats t ≥ 0 :=
  sorry

theorem count_below_total : ∀ (t : Town) (n : Nat),
  countDeafRats t ≤ n :=
  sorry

theorem spaces_dont_matter : ∀ (t1 t2 : Town),
  countDeafRats t1 = countDeafRats t2 :=
  sorry

theorem single_rat_direction : ∀ (t : Town) (r : RatPair),
  countDeafRats t ≤ 1 :=
  sorry

theorem empty_town_count :  
  countDeafRats "P" = 0 :=
  sorry
