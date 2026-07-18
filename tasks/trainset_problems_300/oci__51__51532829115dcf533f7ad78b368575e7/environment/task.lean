-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def LongestStringLength_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def LongestStringLength (strings : List String) (h_precond : LongestStringLength_precond strings) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def LongestStringLength_postcond (strings : List String) (result : Int)
    (h_precond : LongestStringLength_precond strings) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
    (strings = [] → result = 0) ∧
    (strings ≠ [] →
      (∃ s, s ∈ strings ∧ result = Int.ofNat s.length) ∧
      ∀ s, s ∈ strings → Int.ofNat s.length ≤ result)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem LongestStringLength_spec_satisfied (strings : List String)
    (h_precond : LongestStringLength_precond strings) :
    LongestStringLength_postcond strings (LongestStringLength strings h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof