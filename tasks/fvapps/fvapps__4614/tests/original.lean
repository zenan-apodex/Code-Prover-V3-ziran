import Mathlib

structure Contestant where
  name : String
  chickenwings : Nat 
  hamburgers : Nat
  hotdogs : Nat
deriving Repr

def contestant_score (c : Contestant) : Nat :=
  sorry

def scoreboard (contestants : List Contestant) : List Contestant :=
  sorry

theorem scoreboard_preserves_length (contestants : List Contestant) :
  List.length (scoreboard contestants) = List.length contestants :=
  sorry

theorem scoreboard_sorted_scores (contestants : List Contestant) 
    (h : contestants.length > 1) :
  let result := scoreboard contestants
  ∀ i : Fin (result.length),
    i.val + 1 < result.length →
    let score₁ := contestant_score (result.get i)
    let score₂ := contestant_score (result.get ⟨i.val + 1, by sorry⟩)
    if score₁ = score₂ 
    then (result.get i).name ≤ (result.get ⟨i.val + 1, by sorry⟩).name 
    else score₁ > score₂ :=
  sorry

theorem empty_scoreboard :
  scoreboard [] = [] :=
  sorry
