-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def palindromeIgnoreNonAlnum_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def palindromeIgnoreNonAlnum (s : String) (h_precond : palindromeIgnoreNonAlnum_precond (s)) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def palindromeIgnoreNonAlnum_postcond (s : String) (result: Bool) (h_precond : palindromeIgnoreNonAlnum_precond (s)) : Prop :=
  -- !benchmark @start postcond
  let cleaned := s.data.filter (fun c => c.isAlpha || c.isDigit) |>.map Char.toLower
let forward := cleaned
let backward := cleaned.reverse

if result then
  forward = backward
else
  forward ≠ backward
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem palindromeIgnoreNonAlnum_spec_satisfied (s: String) (h_precond : palindromeIgnoreNonAlnum_precond (s)) :
    palindromeIgnoreNonAlnum_postcond (s) (palindromeIgnoreNonAlnum (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


