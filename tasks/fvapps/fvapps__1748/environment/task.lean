import Mathlib

structure TurretInfo where
  range : Int
  shots : Int

/-- tower_defense is a function that takes a grid (array of strings), 
    turrets (mapping characters to turret info),
    and wave (list of integers) and returns an integer -/
def tower_defense (grid : Array String) (turrets : List (Char × TurretInfo)) 
                  (wave : List Int) : Int :=
  sorry

def list_sum : List Int → Int 
  | [] => 0
  | x::xs => x + list_sum xs

/-- The tower_defense function returns a non-negative integer result -/
theorem tower_defense_returns_nonneg (grid : Array String) 
        (turrets : List (Char × TurretInfo)) (wave : List Int)
        (h : turrets.length > 0) :
  0 ≤ tower_defense grid turrets wave := sorry

/-- The tower_defense result is at most the sum of the wave numbers -/
theorem tower_defense_leq_wave_sum (grid : Array String)
        (turrets : List (Char × TurretInfo)) (wave : List Int)  
        (h : turrets.length > 0) :
  tower_defense grid turrets wave ≤ list_sum wave := sorry

/-- The tower_defense function returns 0 for an empty wave -/ 
theorem tower_defense_empty_wave (grid : Array String)
        (turrets : List (Char × TurretInfo))
        (h : turrets.length > 0) :
  tower_defense grid turrets [] = 0 := sorry
