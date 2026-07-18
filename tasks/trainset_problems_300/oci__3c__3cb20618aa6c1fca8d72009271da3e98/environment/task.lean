-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def FindLargestAndSmallest_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def FindLargestAndSmallest (nums : List Int) (h_precond : FindLargestAndSmallest_precond nums) :
    Option Int × Option Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def FindLargestAndSmallest_postcond (nums : List Int) (result : Option Int × Option Int)
    (h_precond : FindLargestAndSmallest_precond nums) : Prop :=
  -- !benchmark @start postcond
  match nums with
  | [] => result = (none, none)
  | _ =>
      ∃ largest smallest : Int,
        result = (some largest, some smallest) ∧
        largest ∈ nums ∧
        smallest ∈ nums ∧
        (∀ x, x ∈ nums → x ≤ largest) ∧
        (∀ x, x ∈ nums → smallest ≤ x)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem FindLargestAndSmallest_spec_satisfied (nums : List Int)
    (h_precond : FindLargestAndSmallest_precond nums) :
    FindLargestAndSmallest_postcond nums (FindLargestAndSmallest nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof