import Mathlib

def isValidGrid (grid : List String) : Bool := sorry

def shortestPathAllKeys (grid : List String) : Int := sorry

theorem shortestPathAllKeys_non_negative_or_neg1 (grid : List String) 
  (h: isValidGrid grid = true) :
  let res := shortestPathAllKeys grid
  res = -1 ∨ res ≥ 0 := sorry

theorem shortestPathAllKeys_geq_keycount (grid : List String) 
  (h: isValidGrid grid = true) :
  let res := shortestPathAllKeys grid
  let keyCount := (grid.map (λ row => row.toList.filter Char.isLower)).join.length
  res = -1 ∨ res ≥ keyCount := sorry

theorem shortestPathAllKeys_empty_grid (grid : List String)
  (h1: grid = ["@"]) :
  shortestPathAllKeys grid = 0 := sorry

theorem shortestPathAllKeys_simple_grid (grid : List String)
  (h1: grid = ["@.", ".."]) :
  shortestPathAllKeys grid = 0 := sorry
