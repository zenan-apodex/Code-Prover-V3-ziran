-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SearchInsert_precond (nums : List Int) (target : Int) : Prop :=
  -- !benchmark @start precond
  List.Pairwise (fun a b => a < b) nums
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SearchInsert (nums : List Int) (target : Int)
    (h_precond : SearchInsert_precond nums target) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsSearchInsertIndex (nums : List Int) (target : Int) (k : Nat) : Prop :=
  k ≤ nums.length ∧
  (∀ i : Nat, i < k → nums[i]! < target) ∧
  (∀ i : Nat, k ≤ i → i < nums.length → target ≤ nums[i]!)
-- !benchmark @end postcond_aux


@[reducible, simp]
def SearchInsert_postcond (nums : List Int) (target : Int) (result : Int)
    (h_precond : SearchInsert_precond nums target) : Prop :=
  -- !benchmark @start postcond
  0 ≤ result ∧ IsSearchInsertIndex nums target (Int.toNat result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SearchInsert_spec_satisfied (nums : List Int) (target : Int)
    (h_precond : SearchInsert_precond nums target) :
    SearchInsert_postcond nums target (SearchInsert nums target h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof