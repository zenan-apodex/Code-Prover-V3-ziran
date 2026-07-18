import Mathlib

structure Hero where
  name : String
  position : String
  health : Nat
  damage : Nat
  experience : Nat
deriving Repr

def Hero.new : Hero := sorry
def Hero.newWithName (name : String) : Hero := sorry

theorem hero_named_properties (name : String) : 
  let hero := Hero.newWithName name
  hero.name = name ∧ 
  hero.position = "00" ∧ 
  hero.health = 100 ∧ 
  hero.damage = 5 ∧ 
  hero.experience = 0 := sorry

theorem hero_default_properties : 
  let hero := Hero.new
  hero.name = "Hero" ∧ 
  hero.position = "00" ∧ 
  hero.health = 100 ∧ 
  hero.damage = 5 ∧ 
  hero.experience = 0 := sorry
