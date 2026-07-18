import Mathlib

variable (solve_frodo_ship : Nat → Nat → Nat × Nat)

theorem power_of_10_boundary (m : Nat) (h : 0 < m) (h2 : m ≤ 100) :
  ∀ i : Nat, 1 ≤ i → i < 5 →
  solve_frodo_ship m (10^i - 1) = (m*i, m) :=
sorry

theorem between_powers (m : Nat) (exp : Nat)
  (h1 : 0 < m) (h2 : m ≤ 10)
  (h3 : 0 < exp) (h4 : exp ≤ 4) :
  solve_frodo_ship m (10^exp - 2) = (m*(exp-1), m) :=
sorry
