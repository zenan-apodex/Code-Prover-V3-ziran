-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def BinarySearch_precond (sorted_list : List Int) (target : Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a ≤ b) sorted_list
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def BinarySearch (sorted_list : List Int) (target : Int)
    (h_precond : BinarySearch_precond sorted_list target) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def BinarySearch_postcond (sorted_list : List Int) (target : Int) (result : Int)
    (h_precond : BinarySearch_precond sorted_list target) : Prop :=
  -- !benchmark @start postcond
  (result = -1 ∧ ∀ i : Nat, i < sorted_list.length → sorted_list[i]! ≠ target) ∨
  (0 ≤ result ∧ Int.toNat result < sorted_list.length ∧ sorted_list[Int.toNat result]! = target)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem BinarySearch_spec_satisfied (sorted_list : List Int) (target : Int)
    (h_precond : BinarySearch_precond sorted_list target) :
    BinarySearch_postcond sorted_list target (BinarySearch sorted_list target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof