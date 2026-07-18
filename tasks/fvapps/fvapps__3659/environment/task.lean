import Mathlib

/-- Empty definition to be filled (mimic pvariance) -/
def pvariance (xs : List String) : Float := sorry

/-- Our variance function -/
def variance (xs : List String) : Float := sorry

/-- Our variance matches statistics.pvariance -/
theorem variance_matches_pvariance (words : List String) (h : words ≠ []) :
  variance words = pvariance words := sorry

/-- Words of same length have variance 0 -/
theorem same_length_zero_variance (words : List String) (h1 : words ≠ []) 
  (h2 : ∀ w ∈ words, w.length = 5) : variance words = 0 := sorry

/-- Variance is always nonnegative -/
theorem variance_nonnegative (words : List String) (h : words.length ≥ 2) :
  variance words ≥ 0 := sorry

/-- Empty list raises error -/
theorem empty_list_error : 
  variance [] = 0/0 := sorry
