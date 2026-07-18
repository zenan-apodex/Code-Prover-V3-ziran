import Mathlib

def alternate_sq_sum (l : List Int) : Int := sorry

theorem alternate_sq_sum_empty :
  alternate_sq_sum [] = 0 := sorry

theorem alternate_sq_sum_formula (l : List Int) :
  alternate_sq_sum l = (List.enum l).foldr (fun (i, x) acc => 
    acc + if i % 2 = 1 then x * x else x) 0 := sorry



theorem alternate_sq_sum_singleton (x : Int) :
  alternate_sq_sum [x] = x := sorry
