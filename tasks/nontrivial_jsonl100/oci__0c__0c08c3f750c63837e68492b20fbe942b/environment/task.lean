-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def hasPath_precond (maze : List (List Int)) : Prop :=
  -- !benchmark @start precond
  maze.length > 0 ∧
  (∀ row ∈ maze, row.length = (maze.head!).length) ∧
  (maze.head!).length > 0 ∧
  (∀ row ∈ maze, ∀ v ∈ row, v = 0 ∨ v = 1) ∧
  (maze.head!).head! = 0 ∧
  (maze.getLast!).getLast! = 0
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def hasPath (maze : List (List Int)) (h_precond : hasPath_precond maze) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Get element at (r, c) in a 2D list, with default 1 (wall). -/
def maze_get (maze : List (List Int)) (r c : Nat) : Int :=
  match maze[r]? with
  | some row => match row[c]? with
    | some v => v
    | none => 1
  | none => 1

/-- Number of rows. -/
def maze_rows (maze : List (List Int)) : Nat := maze.length

/-- Number of columns. -/
def maze_cols (maze : List (List Int)) : Nat :=
  match maze[0]? with
  | some row => row.length
  | none => 0

/-- A step is a pair of grid coordinates (row, col). -/
def mazeNeighbor (a b : Nat × Nat) : Prop :=
  (a.1 = b.1 ∧ (a.2 + 1 = b.2 ∨ b.2 + 1 = a.2)) ∨
  (a.2 = b.2 ∧ (a.1 + 1 = b.1 ∨ b.1 + 1 = a.1))

/-- Every cell in the path is within bounds and is open (value 0). -/
def validCell (maze : List (List Int)) (p : Nat × Nat) : Prop :=
  p.1 < maze_rows maze ∧
  p.2 < maze_cols maze ∧
  maze_get maze p.1 p.2 = 0

/-- A path is a non-empty list of cells where consecutive cells are neighbors. -/
def isPath (maze : List (List Int)) (path : List (Nat × Nat)) : Prop :=
  path.length > 0 ∧
  (∀ c ∈ path, validCell maze c) ∧
  (∀ i, i + 1 < path.length → mazeNeighbor (path[i]!) (path[i + 1]!))

/-- There exists a path from (0,0) to (N-1, M-1). -/
def mazePathExists (maze : List (List Int)) : Prop :=
  ∃ path : List (Nat × Nat),
    isPath maze path ∧
    path.head! = (0, 0) ∧
    path.getLast! = (maze_rows maze - 1, maze_cols maze - 1)
-- !benchmark @end postcond_aux


@[reducible, simp]
def hasPath_postcond (maze : List (List Int)) (result : Bool) (h_precond : hasPath_precond maze) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ mazePathExists maze)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem hasPath_spec_satisfied (maze : List (List Int)) (h_precond : hasPath_precond maze) :
    hasPath_postcond maze (hasPath maze h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof