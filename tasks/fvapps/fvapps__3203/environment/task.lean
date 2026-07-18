import Mathlib

structure ManaMap where
  generic : Nat
  white : Nat
  blue : Nat
  black : Nat
  red : Nat
  green : Nat
deriving Repr

def ManaMap.empty : ManaMap := ⟨0,0,0,0,0,0⟩

def parse_mana_cost (s : String) : Option ManaMap := sorry

theorem parse_mana_cost_valid_keys (s : String) (result : ManaMap) :
  parse_mana_cost s = some result →
  result.white ≥ 0 ∧ result.blue ≥ 0 ∧ result.black ≥ 0 ∧ 
  result.red ≥ 0 ∧ result.green ≥ 0 ∧ result.generic ≥ 0 := sorry

theorem parse_mana_cost_positive_values (s : String) (result : ManaMap) : 
  parse_mana_cost s = some result →
  (result.white > 0 → result.white > 0) ∧
  (result.blue > 0 → result.blue > 0) ∧
  (result.black > 0 → result.black > 0) ∧
  (result.red > 0 → result.red > 0) ∧
  (result.green > 0 → result.green > 0) ∧
  (result.generic > 0 → result.generic > 0) := sorry

theorem parse_mana_cost_length (s : String) (result : ManaMap) :
  parse_mana_cost s = some result →
  result.white + result.blue + result.black + result.red + result.green +
  (if result.generic > 0 then toString result.generic |>.length else 0) = s.length := sorry

theorem parse_mana_cost_invalid (s : String) :
  (∃ c ∈ s.data, ¬(c.toLower ∈ ['w', 'u', 'b', 'r', 'g'] ∨ c.isDigit)) →
  parse_mana_cost s = none := sorry

theorem parse_mana_cost_constructed (generic : Nat) (colors : List Char) :
  let mana := (if generic > 0 then toString generic else "") ++ String.mk colors
  let result := parse_mana_cost mana
  match result with
  | some m => 
    (generic > 0 → m.generic = generic) ∧
    (colors.countP (· = 'w') > 0 → m.white = colors.countP (· = 'w')) ∧
    (colors.countP (· = 'u') > 0 → m.blue = colors.countP (· = 'u')) ∧
    (colors.countP (· = 'b') > 0 → m.black = colors.countP (· = 'b')) ∧
    (colors.countP (· = 'r') > 0 → m.red = colors.countP (· = 'r')) ∧
    (colors.countP (· = 'g') > 0 → m.green = colors.countP (· = 'g'))
  | none => True := sorry
