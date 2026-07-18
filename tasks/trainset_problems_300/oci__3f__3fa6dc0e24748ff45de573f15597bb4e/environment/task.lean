-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def IsStringRotation (s1 s2 : String) : Prop :=
  s1.length = s2.length ∧
  ∃ n : Nat,
    n ≤ s1.toList.length ∧
    s2.toList = s1.toList.drop n ++ s1.toList.take n
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsRotation_precond (s1 : String) (s2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def IsRotation (s1 : String) (s2 : String) (h_precond : IsRotation_precond s1 s2) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def IsRotation_postcond (s1 : String) (s2 : String) (result : Bool)
    (h_precond : IsRotation_precond s1 s2) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ IsStringRotation s1 s2
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem IsRotation_spec_satisfied (s1 : String) (s2 : String)
    (h_precond : IsRotation_precond s1 s2) :
    IsRotation_postcond s1 s2 (IsRotation s1 s2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof