import Mathlib

inductive Weekday where
  | Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday
  | Sunday
  deriving Repr

structure Date where
  day : Nat
  month : Nat
  year : Nat

def isValidDate (d : Date) : Bool := sorry

def get_day_for_date (day month year : Nat) : Option Weekday := sorry

theorem get_day_for_date_valid_output 
  {day month year : Nat}
  (h1: 1 ≤ day ∧ day ≤ 31)
  (h2: 1 ≤ month ∧ month ≤ 12) 
  (h3: 1 ≤ year ∧ year ≤ 9999)
  (h4: isValidDate ⟨day, month, year⟩ = true) :
  ∃ w : Weekday, get_day_for_date day month year = some w :=
sorry

theorem get_day_for_date_invalid_dates :
  get_day_for_date 31 2 2023 = none :=
sorry

theorem get_day_for_date_invalid_zero
  {day month year : Nat}
  (h1: day = 0 ∨ month = 0) :
  get_day_for_date day month year = none :=
sorry
