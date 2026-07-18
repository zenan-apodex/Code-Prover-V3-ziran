-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def BinarySearchFirstOccurrence_precond (arr : List Int) (target : Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a ≤ b) arr
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def BinarySearchFirstOccurrence (arr : List Int) (target : Int)
    (h_precond : BinarySearchFirstOccurrence_precond arr target) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def BinarySearchFirstOccurrence_postcond (arr : List Int) (target : Int)
    (result : List Int) (h_precond : BinarySearchFirstOccurrence_precond arr target) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun i j => i < j) result ∧
  (∀ k : Int, k ∈ result ↔ 0 ≤ k ∧ Int.toNat k < arr.length ∧ arr[Int.toNat k]! = target)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem BinarySearchFirstOccurrence_spec_satisfied (arr : List Int) (target : Int)
    (h_precond : BinarySearchFirstOccurrence_precond arr target) :
    BinarySearchFirstOccurrence_postcond arr target
      (BinarySearchFirstOccurrence arr target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof