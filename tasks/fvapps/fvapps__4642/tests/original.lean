import Mathlib

inductive PokemonType where
  | electric
  | fire 
  | grass
  | water
  deriving Repr, BEq

def calculate_damage (your_type: PokemonType) (opponent_type: PokemonType) (attack: Nat) (defense: Nat) : Nat :=
  sorry

theorem damage_always_positive (your_type: PokemonType) (opponent_type: PokemonType) 
    (attack: Nat) (defense: Nat) (h1: attack > 0) (h2: defense > 0) :
  calculate_damage your_type opponent_type attack defense > 0 :=
sorry

theorem damage_decreases_with_defense (your_type: PokemonType) (opponent_type: PokemonType)
    (attack: Nat) (defense1 defense2: Nat) (h1: defense1 < defense2) :
  calculate_damage your_type opponent_type attack defense1 ≥ 
  calculate_damage your_type opponent_type attack defense2 :=
sorry

theorem damage_increases_with_attack (your_type: PokemonType) (opponent_type: PokemonType)
    (attack1 attack2: Nat) (defense: Nat) (h1: attack1 < attack2) :
  calculate_damage your_type opponent_type attack1 defense ≤
  calculate_damage your_type opponent_type attack2 defense :=
sorry
