-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CompareStrings_precond (s1 : String) (s2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CompareStrings (s1 : String) (s2 : String) (h_precond : CompareStrings_precond s1 s2) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def CaseInsensitiveEq (s1 s2 : String) : Prop :=
  let cs1 := s1.toList
  let cs2 := s2.toList
  cs1.length = cs2.length ∧
    ∀ i : Nat, i < cs1.length → (cs1[i]!).toLower = (cs2[i]!).toLower
-- !benchmark @end postcond_aux


@[reducible, simp]
def CompareStrings_postcond (s1 : String) (s2 : String) (result : Bool)
    (h_precond : CompareStrings_precond s1 s2) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ CaseInsensitiveEq s1 s2
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CompareStrings_spec_satisfied (s1 : String) (s2 : String)
    (h_precond : CompareStrings_precond s1 s2) :
    CompareStrings_postcond s1 s2 (CompareStrings s1 s2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof