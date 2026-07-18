import Mathlib

def ghostbusters (s : String) : String := sorry

theorem ghostbusters_with_spaces (s : String) (h : String.contains s ' ') :
  ghostbusters s = s.replace " " "" := sorry

theorem ghostbusters_without_spaces (s : String) (h : ¬String.contains s ' ') :
  ghostbusters s = "You just wanted my autograph didn't you?" := sorry
