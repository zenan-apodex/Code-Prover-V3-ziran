import Mathlib

inductive Weather where
  | Sunny : Weather
  | Cloudy : Weather
  | Rainy : Weather
deriving BEq, Repr

def take_umbrella (w: Weather) (rain_chance: Float): Bool :=
  sorry

theorem take_umbrella_rainy (rain_chance: Float):
  rain_chance ≥ 0 ∧ rain_chance ≤ 1 →
  take_umbrella Weather.Rainy rain_chance = true :=
  sorry

theorem take_umbrella_sunny (rain_chance: Float):
  rain_chance ≥ 0 ∧ rain_chance ≤ 1 →
  take_umbrella Weather.Sunny rain_chance = (rain_chance > 0.5) :=
  sorry

theorem take_umbrella_cloudy (rain_chance: Float):
  rain_chance ≥ 0 ∧ rain_chance ≤ 1 →
  take_umbrella Weather.Cloudy rain_chance = (rain_chance > 0.2) :=
  sorry

theorem take_umbrella_returns_bool (w: Weather) (rain_chance: Float):
  rain_chance ≥ 0 ∧ rain_chance ≤ 1 →
  (take_umbrella w rain_chance = true ∨ take_umbrella w rain_chance = false) :=
  sorry

theorem take_umbrella_rainy_edge_cases:
  take_umbrella Weather.Rainy 0.0 = true ∧ 
  take_umbrella Weather.Rainy 1.0 = true :=
  sorry
