-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MinSteps_precond (grid : List (List Int)) (start_ : Int × Int) (end_ : Int × Int) : Prop :=
  -- !benchmark @start precond
  let m := grid.length
  m > 0 ∧
  (∀ row ∈ grid, row.length = grid[0]!.length) ∧
  grid[0]!.length > 0 ∧
  0 ≤ start_.1 ∧ start_.1 < m ∧ 0 ≤ start_.2 ∧ start_.2 < grid[0]!.length ∧
  0 ≤ end_.1 ∧ end_.1 < m ∧ 0 ≤ end_.2 ∧ end_.2 < grid[0]!.length ∧
  (∀ row ∈ grid, ∀ v ∈ row, v = 0 ∨ v = 1) ∧
  (grid[start_.1.toNat]!)[start_.2.toNat]! = 0 ∧
  (grid[end_.1.toNat]!)[end_.2.toNat]! = 0
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MinSteps (grid : List (List Int)) (start_ : Int × Int) (end_ : Int × Int) (h_precond : MinSteps_precond grid start_ end_) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A path is a list of (row, col) positions. It is valid on the grid if:
    - It is nonempty
    - It starts at `s` and ends at `e`
    - Every position is in bounds and on an open cell (value 0)
    - Consecutive positions differ by exactly one step in a cardinal direction -/
def IsValidPath (grid : List (List Int)) (s e : Int × Int) (path : List (Int × Int)) : Prop :=
  path.length ≥ 1 ∧
  path.head? = some s ∧
  path.getLast? = some e ∧
  (∀ p ∈ path,
    0 ≤ p.1 ∧ p.1 < grid.length ∧
    0 ≤ p.2 ∧ p.2 < (grid[0]!).length ∧
    (grid[p.1.toNat]!)[p.2.toNat]! = 0) ∧
  (∀ i : Nat, i + 1 < path.length →
    let a := path[i]!
    let b := path[i+1]!
    (a.1 = b.1 ∧ (a.2 = b.2 + 1 ∨ a.2 = b.2 - 1)) ∨
    (a.2 = b.2 ∧ (a.1 = b.1 + 1 ∨ a.1 = b.1 - 1)))
-- !benchmark @end postcond_aux


@[reducible, simp]
def MinSteps_postcond (grid : List (List Int)) (start_ : Int × Int) (end_ : Int × Int) (result : Int) (h_precond : MinSteps_precond grid start_ end_) : Prop :=
  -- !benchmark @start postcond
  (result = -1 →
    ¬ ∃ path, IsValidPath grid start_ end_ path) ∧
  (result ≥ 0 →
    (∃ path, IsValidPath grid start_ end_ path ∧ path.length = result.toNat + 1) ∧
    (∀ path, IsValidPath grid start_ end_ path → path.length ≥ result.toNat + 1)) ∧
  (result = -1 ∨ result ≥ 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MinSteps_spec_satisfied (grid : List (List Int)) (start_ : Int × Int) (end_ : Int × Int) (h_precond : MinSteps_precond grid start_ end_) :
    MinSteps_postcond grid start_ end_ (MinSteps grid start_ end_ h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof