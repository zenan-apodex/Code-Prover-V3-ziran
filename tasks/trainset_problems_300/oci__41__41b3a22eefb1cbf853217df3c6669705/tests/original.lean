-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def BinarySearch_precond (arr : List Int) (target : Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a < b) arr
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def BinarySearch (arr : List Int) (target : Int) (h_precond : BinarySearch_precond arr target) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def BinarySearch_postcond (arr : List Int) (target : Int) (result : Int)
    (h_precond : BinarySearch_precond arr target) : Prop :=
  -- !benchmark @start postcond
  (result = (-1) ∧ target ∉ arr) ∨
    ∃ i : Nat, result = (i : Int) ∧ i < arr.length ∧ arr[i]? = some target
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem BinarySearch_spec_satisfied (arr : List Int) (target : Int)
    (h_precond : BinarySearch_precond arr target) :
    BinarySearch_postcond arr target (BinarySearch arr target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof