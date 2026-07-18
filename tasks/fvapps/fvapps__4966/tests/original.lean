import Mathlib

structure Robot where
  name : String
  health : Nat
  speed : Nat
  tactics : List String
deriving Repr

structure Tactics where
  val : List (String × Nat)
deriving Repr

def fight (r1 r2 : Robot) (t : Tactics) : String :=
  sorry

theorem fight_returns_valid_result (r1 r2 : Robot) (t : Tactics) :
  let result := fight r1 r2 t
  (result = s!"{r1.name} has won the fight." ∨ 
   result = s!"{r2.name} has won the fight." ∨
   result = "The fight was a draw.") :=
sorry

theorem faster_robot_attacks_first (r1 r2 : Robot) (t : Tactics) :
  r1.speed ≠ r2.speed →
  r1.tactics ≠ [] →
  r2.tactics ≠ [] →
  let faster := if r1.speed > r2.speed then r1 else r2
  let slower := if r1.speed > r2.speed then r2 else r1
  let firstDamage := match faster.tactics.head? with
    | none => 0 
    | some tactic => match t.val.lookup tactic with
      | none => 0
      | some dmg => dmg
  firstDamage ≥ slower.health →
  fight r1 r2 t = s!"{faster.name} has won the fight." :=
sorry

theorem equal_health_no_tactics_draws (r1 r2 : Robot) (t : Tactics) :
  r1.health = r2.health →
  r1.tactics = [] →
  r2.tactics = [] →
  fight r1 r2 t = "The fight was a draw." :=
sorry
