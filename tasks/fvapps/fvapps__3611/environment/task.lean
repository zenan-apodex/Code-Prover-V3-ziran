import Mathlib

structure Player where
  name : String
  points : Nat
  position : Nat := 0
deriving Repr, Inhabited

def ranking (players : List Player) : List Player :=
  sorry

theorem ranking_length_preservation (players : List Player) :
  (ranking players).length = players.length :=
  sorry

theorem ranking_min_position (players : List Player) :
  players ≠ [] → 
  (List.map Player.position (ranking players)).head! > 0 ∧
  (List.map Player.position (ranking players)).head! ≤ 1 :=
  sorry

theorem ranking_equal_points_equal_position (players : List Player) :
  ∀ i : Nat, i + 1 < (ranking players).length →
    let result := ranking players
    (result[i]!.points = result[i+1]!.points) →
    (result[i]!.position = result[i+1]!.position) :=
  sorry

theorem ranking_points_position_relation (players : List Player) :
  ∀ i : Nat, i + 1 < (ranking players).length →
    let result := ranking players
    (result[i]!.points > result[i+1]!.points) →
    (result[i]!.position < result[i+1]!.position) :=
  sorry

theorem ranking_points_descending (players : List Player) :
  ∀ i : Nat, i + 1 < (ranking players).length →
    let result := ranking players
    result[i]!.points ≥ result[i+1]!.points :=
  sorry

theorem ranking_names_ascending_same_points (players : List Player) :
  ∀ i : Nat, i + 1 < (ranking players).length →
    let result := ranking players
    result[i]!.points = result[i+1]!.points →
    result[i]!.name ≤ result[i+1]!.name :=
  sorry
