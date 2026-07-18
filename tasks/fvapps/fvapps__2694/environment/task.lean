import Mathlib

inductive Activity where
  | life : Activity
  | eating : Activity
  | kata : Activity
  | petes_kata : Activity
deriving BEq

def points : Activity → Nat 
  | Activity.life => 0
  | Activity.eating => 1
  | Activity.kata => 5
  | Activity.petes_kata => 10

def sumList : List Nat → Nat  
  | [] => 0
  | h :: t => h + sumList t

def paul (activities: List Activity) : String := sorry

theorem paul_returns_valid_mood (activities : List Activity) (h : activities.length ≥ 1) : 
  paul activities = "Miserable!" ∨ 
  paul activities = "Sad!" ∨ 
  paul activities = "Happy!" ∨ 
  paul activities = "Super happy!" := sorry

theorem paul_points_thresholds (activities : List Activity) (h : activities.length ≥ 1) :
  let total := sumList (activities.map points)
  if total ≥ 100 then
    paul activities = "Miserable!"
  else if total ≥ 70 then 
    paul activities = "Sad!"
  else if total ≥ 40 then
    paul activities = "Happy!"
  else
    paul activities = "Super happy!" := sorry

theorem paul_returns_string (activities : List Activity) :
  ∃ s : String, paul activities = s := sorry
