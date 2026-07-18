-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def reverseString_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def reverseString (s : String) (h_precond : reverseString_precond (s)) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def reverseString_postcond (s : String) (result: String) (h_precond : reverseString_precond (s)) : Prop :=
  -- !benchmark @start postcond
  result.length = s.length ∧ result.toList = s.toList.reverse
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem reverseString_spec_satisfied (s: String) (h_precond : reverseString_precond (s)) :
    reverseString_postcond (s) (reverseString (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


