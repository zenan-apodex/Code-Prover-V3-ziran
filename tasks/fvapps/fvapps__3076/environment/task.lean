import Mathlib

inductive Direction where
  | Begin : Direction
  | Left : Direction
  | Right : Direction
  deriving Repr, BEq, Inhabited

def solve : List String → List String := sorry

def extractDirections (commands : List String) : List Direction := sorry

def extractRoads (commands : List String) : List String := sorry

def isLeftOrRight (d : Direction) : Bool :=
  match d with
  | Direction.Left => true
  | Direction.Right => true
  | _ => false

def allLeftOrRight (directions : List Direction) : Bool := 
  directions.all isLeftOrRight

theorem solution_preserves_length (commands : List String) :
  List.length (solve commands) = List.length commands := sorry

theorem solution_preserves_roads (commands : List String) :
  extractRoads (solve commands) = extractRoads commands := sorry

theorem first_direction_valid (commands : List String) :
  commands ≠ [] →
  let result := solve commands
  let firstDir := extractDirections result |>.head!
  firstDir = Direction.Begin ∨ firstDir = Direction.Left ∨ firstDir = Direction.Right := sorry

theorem directions_alternate (commands : List String) :
  List.length commands > 1 →
  allLeftOrRight (List.tail! (extractDirections (solve commands))) := sorry
