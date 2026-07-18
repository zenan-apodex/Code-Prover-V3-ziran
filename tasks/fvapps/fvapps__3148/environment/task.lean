import Mathlib

inductive Dir where
  | left : Dir
  | right : Dir 
  | up : Dir
  | down : Dir
  deriving Repr, BEq

def dirList := List Dir

def getEndpoint (path : dirList) : Int × Int := sorry

def simplify (path : dirList) : dirList := sorry 

theorem simplify_same_endpoint (path : dirList) : 
  getEndpoint path = getEndpoint (simplify path) := sorry

theorem simplify_shorter (path : dirList) :
  (simplify path).length ≤ path.length := sorry

theorem simplify_empty (path : dirList) :
  path = [] → simplify path = [] := sorry

def isValidDir (d : Dir) : Bool := sorry

theorem simplify_valid_chars (path : dirList) (d : Dir) :
  List.elem d (simplify path) → isValidDir d := sorry

theorem simplify_idempotent (path : dirList) :
  simplify (simplify path) = simplify path := sorry
