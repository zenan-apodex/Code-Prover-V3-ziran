import Mathlib

inductive ShipClass where
  | BattleShip
  | Cruiser
  | Destroyer
  | Frigate
deriving Repr

def get_ship_class (c : Char) : ShipClass := sorry

theorem get_ship_class_returns_valid_type (c : Char) :
  get_ship_class c = ShipClass.BattleShip ∨ 
  get_ship_class c = ShipClass.Cruiser ∨
  get_ship_class c = ShipClass.Destroyer ∨ 
  get_ship_class c = ShipClass.Frigate :=
sorry

theorem get_ship_class_case_insensitive_B (c : Char) :
  (c = 'B' ∨ c = 'b') → get_ship_class c = ShipClass.BattleShip :=
sorry

theorem get_ship_class_case_insensitive_C (c : Char) :
  (c = 'C' ∨ c = 'c') → get_ship_class c = ShipClass.Cruiser :=
sorry

theorem get_ship_class_case_insensitive_D (c : Char) :
  (c = 'D' ∨ c = 'd') → get_ship_class c = ShipClass.Destroyer :=
sorry

theorem get_ship_class_default (c : Char) :
  (c.toUpper ≠ 'B' ∧ c.toUpper ≠ 'C' ∧ c.toUpper ≠ 'D') → 
  get_ship_class c = ShipClass.Frigate :=
sorry
