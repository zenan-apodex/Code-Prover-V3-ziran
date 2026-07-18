import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/-- For real numbers \(a\) and \(c\), prove the inequality:
$$2a(2+c) \le a^2+c^2+4(1+c)$$ -/
theorem algebra_sqineq_2at2pclta2c2p41pc (a c : ℝ) :
    2 * a * (2 + c) ≤ a ^ 2 + c ^ 2 + 4 * (1 + c) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
