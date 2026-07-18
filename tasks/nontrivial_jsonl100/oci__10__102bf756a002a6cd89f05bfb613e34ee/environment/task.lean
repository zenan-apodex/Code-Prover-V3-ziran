-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def ReadFile_precond (fileContent : Option String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def ReadFile (fileContent : Option String) (h_precond : ReadFile_precond fileContent) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def ReadFile_postcond (fileContent : Option String) (result : String) (h_precond : ReadFile_precond fileContent) : Prop :=
  -- !benchmark @start postcond
  match fileContent with
  | some content => result = content
  | none => result.length > 0  -- error message is non-empty
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem ReadFile_spec_satisfied (fileContent : Option String) (h_precond : ReadFile_precond fileContent) :
    ReadFile_postcond fileContent (ReadFile fileContent h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof