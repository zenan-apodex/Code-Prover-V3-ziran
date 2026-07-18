import Mathlib

def solve (s : String) : Nat :=
  sorry

theorem solve_bounds {s : String} (h : s.length > 0) :
  solve s ≥ 0 ∧ solve s ≤ (s.length * (s.length + 1)) / 2 :=
  sorry

theorem solve_expected {s : String} (h : s.length > 0) :
  solve s = s.data.enum.foldl (fun acc (i, c) => 
    if c.toNat % 2 = 1 then 
      acc + (i + 1)
    else acc) 0 :=
  sorry

theorem solve_even_only {s : String} (h : s.length > 0)
  (h_even : ∀ c ∈ s.data, c.toNat % 2 = 0) :
  solve s = 0 :=
  sorry

theorem solve_odd_only {s : String} (h : s.length > 0)
  (h_odd : ∀ c ∈ s.data, c.toNat % 2 = 1) :
  solve s = (s.length * (s.length + 1)) / 2 :=
  sorry
