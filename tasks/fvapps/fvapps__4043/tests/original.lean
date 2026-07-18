import Mathlib

abbrev Matrix := List (List Nat)

def calcGame (gamemap : Matrix) : Nat := sorry

def rotateMatrix (m : Matrix) : Matrix := sorry

def getMinValue (gamemap : Matrix) : Nat :=
  gamemap.map (List.foldl min 0) |> List.foldl min 0

theorem gamemap_value_minimum {gamemap : Matrix} : 
  getMinValue gamemap ≤ calcGame gamemap := sorry

theorem gamemap_rotation_symmetry {gamemap : Matrix} :
  calcGame gamemap = calcGame (rotateMatrix gamemap) := sorry

theorem gamemap_monotonicity {gamemap : Matrix} {increased : Matrix} :
  (∀ i j, (gamemap.get! i).get! j + 1 = (increased.get! i).get! j) →
  calcGame gamemap ≤ calcGame increased := sorry
