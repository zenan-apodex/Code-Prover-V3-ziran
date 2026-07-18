import Mathlib

open scoped Nat
open scoped Real

/--
Let $\mathbb{Z}$ be the set of integers. Determine all functions $f: \mathbb{Z} \rightarrow \mathbb{Z}$ such that, for all integers $a$ and $b$, $$f(2a)+2f(b)=f(f(a+b)).$$
[i]Proposed by Liam Baker, South Africa[/i]
-/
theorem imo_2019_p1 (f : ℤ → ℤ) :
    (∀ a b, f (2 * a) + 2 * f b = f (f (a + b))) ↔ ∀ z, f z = 0 ∨ ∃ c, ∀ z, f z = 2 * z + c := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
