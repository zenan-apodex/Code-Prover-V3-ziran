-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def StringIsPalindrome (s : String) : Prop :=
  s.data.reverse = s.data
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPalindrome_precond (x : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def IsPalindrome (x : Int) (h_precond : IsPalindrome_precond x) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def IsPalindrome_postcond (x : Int) (result : Bool)
    (h_precond : IsPalindrome_precond x) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ StringIsPalindrome (toString x)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem IsPalindrome_spec_satisfied (x : Int)
    (h_precond : IsPalindrome_precond x) :
    IsPalindrome_postcond x (IsPalindrome x h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof