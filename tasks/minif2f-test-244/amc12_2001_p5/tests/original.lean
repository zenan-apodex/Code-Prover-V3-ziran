import Mathlib

open scoped Nat
open scoped Real

/--
What is the product of all odd positive integers less than 10000?

$ \textbf{(A)} \ \frac {10000!}{(5000!)^2} \qquad \textbf{(B)} \ \frac {10000!}{2^{5000}} \ \qquad \textbf{(C)} \ \frac {9999!}{2^{5000}} \qquad \textbf{(D)} \ \frac {10000!}{2^{5000} \cdot 5000!} \qquad \textbf{(E)} \ \frac {5000!}{2^{5000}}$
-/
theorem amc12_2001_p5 :
    Finset.prod (Finset.filter (fun x => ¬Even x) (Finset.range 10000)) (id : ℕ → ℕ) =
      10000! / (2 ^ 5000 * 5000!) := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
