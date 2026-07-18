-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def allCharactersSame_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def allCharactersSame (s : String) (h_precond : allCharactersSame_precond (s)) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def allCharactersSame_postcond (s : String) (result: Bool) (h_precond : allCharactersSame_precond (s)) :=
  -- !benchmark @start postcond
  let cs := s.toList
  (result → List.Pairwise (· = ·) cs) ∧
  (¬ result → (cs ≠ [] ∧ cs.any (fun x => x ≠ cs[0]!)))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem allCharactersSame_spec_satisfied (s: String) (h_precond : allCharactersSame_precond (s)) :
    allCharactersSame_postcond (s) (allCharactersSame (s) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
