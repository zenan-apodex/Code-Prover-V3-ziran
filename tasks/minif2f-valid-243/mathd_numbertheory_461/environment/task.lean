import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $n$ be the number of integers $m$ in the range $1\le m\le 8$ such that $\text{gcd}(m,8)=1$. What is the remainder when $3^n$ is divided by $8$? -/
theorem mathd_numbertheory_461 (n : ℕ)
    (h₀ : n = Finset.card (Finset.filter (fun x => gcd x 8 = 1) (Finset.Icc 1 7))) :
    3 ^ n % 8 = (1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
