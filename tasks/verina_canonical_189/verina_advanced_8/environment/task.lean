-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def canCompleteCircuit_precond (gas : List Int) (cost : List Int) : Prop :=
  -- !benchmark @start precond
  gas.length > 0 ∧ gas.length = cost.length
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def canCompleteCircuit (gas : List Int) (cost : List Int) (h_precond : canCompleteCircuit_precond (gas) (cost)) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def canCompleteCircuit_postcond (gas : List Int) (cost : List Int) (result: Int) (h_precond : canCompleteCircuit_precond (gas) (cost)) : Prop :=
  -- !benchmark @start postcond
  let valid (start : Nat) := List.range gas.length |>.all (fun i =>
    let acc := List.range (i + 1) |>.foldl (fun t j =>
      let jdx := (start + j) % gas.length
      t + gas[jdx]! - cost[jdx]!) 0
    acc ≥ 0)
  -- The result is either -1 or a valid starting index
  (result ≥ -1) ∧
  -- For result = -1: It's impossible to complete the circuit starting from any index
  -- In other words, there's no starting point from which we can always maintain a non-negative gas tank
  (result = -1 → (List.range gas.length).all (fun start => ¬ valid start)) ∧
  -- For result ≥ 0: This is the valid starting point
  -- When starting from this index, the gas tank never becomes negative during the entire circuit
  (result ≥ 0 → result < gas.length ∧ valid result.toNat ∧ (List.range result.toNat).all (fun start => ¬ valid start))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem canCompleteCircuit_spec_satisfied (gas: List Int) (cost: List Int) (h_precond : canCompleteCircuit_precond (gas) (cost)) :
    canCompleteCircuit_postcond (gas) (cost) (canCompleteCircuit (gas) (cost) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
