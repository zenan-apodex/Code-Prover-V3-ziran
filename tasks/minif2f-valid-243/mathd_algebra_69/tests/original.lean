import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
An audience of $450$ people is seated in an auditorium. Each row contains the same number of seats and each seat in the auditorium is occupied. With three fewer seats per row, and five extra rows, the same audience could still be seated, occupying all seats. How many rows does the auditorium have? -/
theorem mathd_algebra_69 (rows seats : ℕ) (h₀ : rows * seats = 450)
    (h₁ : (rows + 5) * (seats - 3) = 450) : rows = (25) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
