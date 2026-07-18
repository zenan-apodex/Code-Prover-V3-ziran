import Mathlib

structure Date where
  year : Int
  month : Nat
  day : Nat
  deriving Repr

def isLeapYear (year : Int) : Bool := sorry

def daysUntilChristmas (d : Date) : Nat := sorry

def addDays (d : Date) (n : Nat) : Date := sorry

theorem days_until_christmas_non_negative (d : Date) : 
  daysUntilChristmas d ≥ 0 := sorry

theorem days_until_christmas_max_bound (d : Date) :
  daysUntilChristmas d ≤ 366 := sorry

theorem days_until_christmas_gives_christmas (d : Date) :
  let future := addDays d (daysUntilChristmas d)
  future.month = 12 ∧ future.day = 25 := sorry

theorem on_christmas_returns_zero (d : Date) (h1 : d.month = 12) (h2 : d.day = 25) :
  daysUntilChristmas d = 0 := sorry

theorem after_christmas_next_year (d : Date) 
  (h1 : d.month = 12) (h2 : d.day > 25) :
  daysUntilChristmas d = 
    daysUntilChristmas (Date.mk (d.year + 1) 12 25) := sorry
