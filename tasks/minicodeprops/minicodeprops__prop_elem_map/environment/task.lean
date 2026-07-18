import Mathlib

theorem prop_elem_map (y: β) (f: α → β) (xs: List α) [DecidableEq β] :
  y ∈ xs.map f → (∃x, (f x) == y ∧ x ∈ xs):= by sorry
