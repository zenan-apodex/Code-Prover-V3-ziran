-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def semiOrderedPermutation_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  let n := nums.length
  n > 0 ∧
  -- Must be a permutation of [1..n]: all distinct, all in range
  List.Nodup nums ∧
  nums.all (fun x => 1 ≤ x ∧ x ≤ Int.ofNat n)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def semiOrderedPermutation (nums : List Int) (h_precond : semiOrderedPermutation_precond (nums)) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def semiOrderedPermutation_postcond (nums : List Int) (result: Int) (h_precond : semiOrderedPermutation_precond (nums)) : Prop :=
  -- !benchmark @start postcond
  let n := nums.length
  let pos1 := nums.idxOf 1
  let posn := nums.idxOf (Int.ofNat n)
  if pos1 > posn then
    pos1 + n = result + 2 + posn
  else
    pos1 + n = result + 1 + posn
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem semiOrderedPermutation_spec_satisfied (nums: List Int) (h_precond : semiOrderedPermutation_precond (nums)) :
    semiOrderedPermutation_postcond (nums) (semiOrderedPermutation (nums) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
