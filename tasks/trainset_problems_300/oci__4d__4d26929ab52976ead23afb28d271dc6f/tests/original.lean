-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindRepeatedUrls_precond (urls : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindRepeatedUrls (urls : List String) (h_precond : FindRepeatedUrls_precond urls) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindRepeatedUrls_postcond (urls : List String) (result : List String)
    (h_precond : FindRepeatedUrls_precond urls) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧
    ∀ url : String, url ∈ result ↔ 1 < urls.count url
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindRepeatedUrls_spec_satisfied (urls : List String)
    (h_precond : FindRepeatedUrls_precond urls) :
    FindRepeatedUrls_postcond urls (FindRepeatedUrls urls h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof