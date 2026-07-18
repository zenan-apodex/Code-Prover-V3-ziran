import Mathlib

inductive Formula where
  | lit (name : String) : Formula
  | and (args : List Formula) : Formula 
  | or (args : List Formula) : Formula
  | not (arg : Formula) : Formula

abbrev Model := List String

def sat (f : Formula) : Option Model := sorry

theorem sat_returns_model_or_false (f : Formula) (m : Model) :
  (sat f = some m) → ∀ s ∈ m, ∃ name, Formula.lit name = Formula.lit s
  := sorry

theorem not_p_and_p_unsatisfiable (p : Formula) :
  sat (Formula.and [p, Formula.not p]) = none 
  := sorry

theorem p_or_not_p_satisfiable (p : Formula) :
  sat (Formula.or [p, Formula.not p]) ≠ none
  := sorry
