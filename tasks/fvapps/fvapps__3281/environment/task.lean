import Mathlib

def unlucky_days (year: Nat) : Nat := sorry

def is_friday_13th (year month: Nat) : Bool := sorry

theorem unlucky_days_bounds (year: Nat) (h: year ≥ 1583): 
  unlucky_days year ≤ 12 := sorry

theorem unlucky_days_nonneg (year: Nat) (h: year ≥ 1583):
  unlucky_days year ≥ 0 := sorry



theorem unlucky_days_400_year_cycle (year: Nat) (h: year ≥ 1583) (i: Nat):
  unlucky_days (year + i) = unlucky_days (year + i + 400) := sorry
