import Mathlib

open scoped Nat
open scoped Real

/--
Let $x$, $y$, and $z$ all exceed 1 and let $w$ be a positive number such that \[\log_x w = 24,\quad \log_y w = 40 \quad\text{and}\quad \log_{xyz} w = 12.\]  Find $\log_z w$.
-/
theorem aime_1983_p1 (x y z w : ℕ) (ht : 1 < x ∧ 1 < y ∧ 1 < z) (hw : 0 ≤ w)
    (h0 : Real.log w / Real.log x = 24) (h1 : Real.log w / Real.log y = 40)
    (h2 : Real.log w / Real.log (x * y * z) = 12) : Real.log w / Real.log z = 60 := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
