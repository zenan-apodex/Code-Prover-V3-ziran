-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindCommonElements_precond (set1 : List Int) (set2 : List Int) : Prop :=
  -- !benchmark @start precond
  set1.Nodup ∧ set2.Nodup
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindCommonElements (set1 : List Int) (set2 : List Int)
    (h_precond : FindCommonElements_precond set1 set2) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindCommonElements_postcond (set1 : List Int) (set2 : List Int) (result : List Int)
    (h_precond : FindCommonElements_precond set1 set2) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧
    ∀ x : Int, x ∈ result ↔ x ∈ set1 ∧ x ∈ set2
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindCommonElements_spec_satisfied (set1 : List Int) (set2 : List Int)
    (h_precond : FindCommonElements_precond set1 set2) :
    FindCommonElements_postcond set1 set2 (FindCommonElements set1 set2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof