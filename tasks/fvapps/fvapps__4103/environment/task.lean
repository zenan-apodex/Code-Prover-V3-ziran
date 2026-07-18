import Mathlib

inductive BehaviorType where
  | Nice : BehaviorType
  | Naughty : BehaviorType
deriving Repr, BEq

def Month := String
def Day := String

def BehaviorMap := List (Month × List (Day × BehaviorType))

def naughty_or_nice (behaviors: BehaviorMap) : String :=
sorry

theorem naughty_or_nice_returns_valid_result (behaviors: BehaviorMap) :
  naughty_or_nice behaviors = "Nice!" ∨ naughty_or_nice behaviors = "Naughty!" :=
sorry

theorem naughty_or_nice_matches_count (behaviors: BehaviorMap) :
  let nice_count := behaviors.foldl (fun acc m => 
    acc + m.2.foldl (fun inner_acc d => 
      inner_acc + match d.2 with
      | BehaviorType.Nice => 1
      | BehaviorType.Naughty => -1) 0) 0
  naughty_or_nice behaviors = if nice_count >= 0 then "Nice!" else "Naughty!" :=
sorry

theorem all_nice_returns_nice (behaviors: BehaviorMap) 
  (h: behaviors.all (fun m => 
      m.2.all (fun d => match d.2 with
        | BehaviorType.Nice => true
        | BehaviorType.Naughty => false))) :
  naughty_or_nice behaviors = "Nice!" :=
sorry
