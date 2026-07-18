import Mathlib

structure ProbDistr where
  dist: List (Int × Float)
  valid: ∀ x, x ∈ dist → x.2 > 0
  sumOne: List.foldl (· + ·) 0 (dist.map (·.2)) = 1

def statsDiscDistr (distrib : List (Int × Float)) : List Float := sorry

theorem valid_distribution_properties
  (distrib : ProbDistr) :
  let result := statsDiscDistr distrib.dist
  -- result is list of length 3
  result.length = 3 ∧
  -- mean, var, std_dev destructuring
  let mean := result[0]!
  let var := result[1]!  
  let std_dev := result[2]!
  -- properties
  var = std_dev * std_dev ∧
  var ≥ 0 ∧
  std_dev ≥ 0 :=
sorry
