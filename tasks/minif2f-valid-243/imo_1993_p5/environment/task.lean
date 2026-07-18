import Mathlib

open scoped Real
open scoped Nat
open scoped Topology
open scoped Polynomial

/--
Let $\mathbb{N} = \{1,2,3, \ldots\}$. Determine if there exists a strictly increasing function $f: \mathbb{N} \mapsto \mathbb{N}$ with the following properties:

(i) $f(1) = 2$;

(ii) $f(f(n)) = f(n) + n, (n \in \mathbb{N})$. -/
theorem imo_1993_p5 : ∃ f : ℕ → ℕ, f 1 = 2 ∧ ∀ n, f (f n) = f n + n ∧ ∀ n, f n < f (n + 1) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
