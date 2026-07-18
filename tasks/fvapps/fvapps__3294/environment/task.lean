import Mathlib

def converter (mpg : Float) : Float := sorry 

namespace converter 

theorem converter_positive {mpg : Float} (h : mpg ≥ 1) : converter mpg > 0 := sorry 

theorem converter_proportional {mpg : Float} (h1 : mpg ≥ 1) (h2 : mpg ≤ 500) : 
  0.30 * mpg ≤ converter mpg ∧ converter mpg ≤ 0.40 * mpg := sorry

end converter
