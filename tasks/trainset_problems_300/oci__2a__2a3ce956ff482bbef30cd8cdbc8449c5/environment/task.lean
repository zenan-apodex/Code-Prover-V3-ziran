-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MaxTeams_precond (developers : Int) (designers : Int) (managers : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ developers ∧ 0 ≤ designers ∧ 0 ≤ managers
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def MaxTeams (developers : Int) (designers : Int) (managers : Int)
    (h_precond : MaxTeams_precond developers designers managers) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def MaxTeams_postcond (developers : Int) (designers : Int) (managers : Int)
    (result : Int) (h_precond : MaxTeams_precond developers designers managers) : Prop :=
  -- !benchmark @start postcond
  0 ≤ result ∧
  result ≤ developers ∧
  result ≤ designers ∧
  result ≤ managers ∧
  (∀ t : Int, 0 ≤ t → t ≤ developers → t ≤ designers → t ≤ managers → t ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem MaxTeams_spec_satisfied (developers : Int) (designers : Int) (managers : Int)
    (h_precond : MaxTeams_precond developers designers managers) :
    MaxTeams_postcond developers designers managers
      (MaxTeams developers designers managers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof