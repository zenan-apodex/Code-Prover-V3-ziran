import Mathlib

def repeated_n_times (arr : List Int) : Option Int := sorry





theorem repeated_n_times_first_repeat {arr : List Int} {n : Int}
  (h : repeated_n_times arr = some n) :
  ∀ x : Int, x ∈ arr → x ≠ n → 
  (arr.take (arr.indexOf x)).count x ≤ 1 := sorry
