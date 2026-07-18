import Mathlib

structure Interval where
  start: Int 
  stop: Int
deriving BEq, Inhabited

def remove_covered_intervals (intervals: List Interval) : Int :=
  sorry



theorem remove_covered_intervals_empty :
  remove_covered_intervals [] = 0 :=
  sorry
