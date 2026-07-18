import Mathlib

inductive Day where
  | Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday
  | Sunday
  deriving BEq, Repr

def day_of_the_week (day month year : Nat) : Day :=
  sorry

def isValidDate (day month year : Nat) : Prop :=
  day ≥ 1 ∧ day ≤ 31 ∧ month ≥ 1 ∧ month ≤ 12

def isLeapYear (year : Nat) : Prop :=
  year % 4 = 0 ∧ (year % 100 ≠ 0 ∨ year = 2000)

theorem valid_dates {day month year : Nat} 
  (hday : day ≥ 1 ∧ day ≤ 31)
  (hmonth : month ≥ 1 ∧ month ≤ 12)
  (hyear : year ≥ 1971 ∧ year ≤ 2100)
  (hvalid : isValidDate day month year) :
  ∃ d : Day, day_of_the_week day month year = d :=
sorry

theorem leap_year {year month : Nat}
  (hyear : year ≥ 1971 ∧ year ≤ 2100)
  (hmonth : month = 2)
  (hleap : isLeapYear year) :
  ∃ d : Day, day_of_the_week 29 2 year = d :=
sorry

theorem year_boundaries {year : Nat}
  (hyear : year ≥ 1971 ∧ year ≤ 2100) :
  ∃ d1 d2 : Day, 
    day_of_the_week 1 1 year = d1 ∧
    day_of_the_week 31 12 year = d2 :=
sorry
