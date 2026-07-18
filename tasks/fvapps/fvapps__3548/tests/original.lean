import Mathlib

def polynomialize (roots: List Int) : String := sorry 

def isValidPolynomial (s: String) : Bool := sorry

theorem polynomial_format 
  (roots: List Int)
  (h1: roots ≠ [])
  (h2: ∀ x ∈ roots, -100 ≤ x ∧ x ≤ 100) :
  isValidPolynomial (polynomialize roots) := sorry

theorem zero_roots
  (zeros: List Int) 
  (h1: zeros.length ≥ 2)
  (h2: zeros.length ≤ 10)
  (h3: ∀ x ∈ zeros, x = 0) :
  polynomialize zeros = s!"x^{zeros.length} = 0" := sorry
