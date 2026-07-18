import Mathlib

structure Time where
  hours : Nat
  minutes : Nat
  h_valid : hours < 24
  m_valid : minutes < 60

def busTimer (t : Time) : Nat := sorry

theorem bus_timer_range_bounds (t : Time) :
  0 ≤ busTimer t ∧ busTimer t ≤ 600 := sorry

theorem exact_hours_normal_hours (t : Time)
  (h : 6 ≤ t.hours ∧ t.hours < 23) (m : t.minutes = 0) :
  busTimer t ≤ 10 := sorry

theorem normal_schedule (t : Time)
  (h : 6 ≤ t.hours ∧ t.hours ≤ 22) :
  busTimer t ≤ 10 := sorry

theorem early_morning_bound (t : Time)
  (h : t.hours ≤ 5) (m : t.minutes = 30) :
  busTimer t ≥ (5 - t.hours) * 60 - 35 := sorry

theorem specific_late_night_values (t : Time) :
  (t.hours = 23 ∧ t.minutes = 56 → busTimer t = 359) ∧
  (t.hours = 23 ∧ t.minutes = 59 → busTimer t = 356) := sorry
