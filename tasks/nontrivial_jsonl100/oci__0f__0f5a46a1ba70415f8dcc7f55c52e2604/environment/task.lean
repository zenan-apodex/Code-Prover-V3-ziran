-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def IsPathExist_precond (maze : List (List Int)) : Prop :=
  -- !benchmark @start precond
  -- All rows have the same length and the maze is non-empty
  maze.length > 0 ∧
  (maze[0]!).length > 0 ∧
  (∀ row ∈ maze, row.length = (maze[0]!).length) ∧
  -- All cells are 0 or 1
  (∀ row ∈ maze, ∀ c ∈ row, c = 0 ∨ c = 1)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def IsPathExist (maze : List (List Int)) (h_precond : IsPathExist_precond maze) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Get cell value at (r, c) in the maze, defaulting to 1 (wall) if out of bounds. -/
def mazeGet (maze : List (List Int)) (r c : Nat) : Int :=
  if r < maze.length then
    let row := maze[r]!
    if c < row.length then row[c]!
    else 1
  else 1

/-- Two cells are adjacent (4-directional neighbors). -/
def adjacent (p q : Nat × Nat) : Prop :=
  (p.1 = q.1 ∧ (p.2 + 1 = q.2 ∨ q.2 + 1 = p.2)) ∨
  (p.2 = q.2 ∧ (p.1 + 1 = q.1 ∨ q.1 + 1 = p.1))

/-- A path in the maze: a list of walkable cells where consecutive cells are adjacent. -/
def isValidPath (maze : List (List Int)) (path : List (Nat × Nat)) : Prop :=
  path.length > 0 ∧
  (∀ p ∈ path, mazeGet maze p.1 p.2 = 0) ∧
  (∀ i, i + 1 < path.length → adjacent (path[i]!) (path[i + 1]!))

/-- There exists a valid path from top-left to bottom-right. -/
def mazeReachable (maze : List (List Int)) : Prop :=
  ∃ path : List (Nat × Nat),
    isValidPath maze path ∧
    path.head? = some (0, 0) ∧
    path.getLast? = some (maze.length - 1, (maze[0]!).length - 1)
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPathExist_postcond (maze : List (List Int)) (result : Bool) (h_precond : IsPathExist_precond maze) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ mazeReachable maze)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem IsPathExist_spec_satisfied (maze : List (List Int)) (h_precond : IsPathExist_precond maze) :
    IsPathExist_postcond maze (IsPathExist maze h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof