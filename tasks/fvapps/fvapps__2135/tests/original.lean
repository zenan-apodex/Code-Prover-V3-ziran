import Mathlib

inductive Direction where
  | N | S | E | W
  deriving BEq

def flipDir : Direction → Direction 
  | Direction.N => Direction.S
  | Direction.S => Direction.N
  | Direction.E => Direction.W
  | Direction.W => Direction.E

def flipPath (path : List Direction) : List Direction :=
  path.map flipDir

def opposite (d : Direction) : Direction :=
  flipDir d

def solvable (p1 p2 : List Direction) : Bool :=
  sorry

theorem solvable_with_self_inverse (path : List Direction) :
  ¬(solvable path (flipPath path)) := by sorry

theorem solvable_symmetry (path : List Direction) :
  let rev := (path.reverse.map opposite)
  solvable path rev = solvable rev path := by sorry
