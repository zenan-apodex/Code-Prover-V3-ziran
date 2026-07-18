import Mathlib

def check_alive (health : Int) : Bool :=
  sorry

theorem check_alive_returns_bool (health : Int) :
  check_alive health = true ∨ check_alive health = false :=
  sorry

theorem check_alive_positive_health (health : Int) :
  check_alive health ↔ health > 0 :=
  sorry
