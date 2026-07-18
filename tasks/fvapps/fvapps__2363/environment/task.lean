import Mathlib

def solve_min_team_diff (n : Nat) (strengths : List Int) : Int :=
  sorry

theorem min_team_diff_non_negative (n : Nat) (strengths : List Int)
  (h1 : n ≥ 2)
  (h2 : strengths.length ≥ n) :
  solve_min_team_diff n strengths ≥ 0 :=
sorry

theorem min_team_diff_upper_bound (n : Nat) (strengths : List Int)
  (h1 : n ≥ 2)
  (h2 : strengths.length ≥ n) :
  solve_min_team_diff n strengths ≤ (List.maximum? strengths).getD 0 - (List.minimum? strengths).getD 0 :=
sorry

theorem min_team_diff_is_minimum (n : Nat) (strengths : List Int)
  (h1 : n ≥ 2)  
  (h2 : strengths.length ≥ n) :
  ∃ min_diff : Int,
    solve_min_team_diff n strengths = min_diff ∧
    ∀ (x y : Int), x ∈ strengths → y ∈ strengths → x ≤ y → min_diff ≤ y - x :=
sorry

theorem min_team_diff_two_elements (a b : Int) :
  solve_min_team_diff 2 [a, b] = Int.natAbs (b - a) :=
sorry

theorem min_team_diff_identical {x : Int} {n : Nat} (lst : List Int)
  (h1 : n ≥ 2)
  (h2 : lst.length = n)
  (h3 : ∀ (i : Fin lst.length), lst.get i = x) :
  solve_min_team_diff n lst = 0 :=
sorry
