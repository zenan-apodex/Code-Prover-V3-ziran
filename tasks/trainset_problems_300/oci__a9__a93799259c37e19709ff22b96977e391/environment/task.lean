-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def IsStrictlyIncreasing (xs : List Int) : Prop :=
  List.Pairwise (fun a b => a < b) xs

def IsRotationOf (xs ys : List Int) : Prop :=
  ∃ n : Nat, n ≤ ys.length ∧ xs = ys.drop n ++ ys.take n
-- !benchmark @end precond_aux

@[reducible, simp]
def FindMaxInRotatedSortedArray_precond (nums : List Int) : Prop :=
  -- !benchmark @start precond
  nums ≠ [] ∧ ∃ base : List Int, IsStrictlyIncreasing base ∧ IsRotationOf nums base
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def FindMaxInRotatedSortedArray (nums : List Int)
    (h_precond : FindMaxInRotatedSortedArray_precond nums) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def FindMaxInRotatedSortedArray_postcond (nums : List Int) (result : Int)
    (h_precond : FindMaxInRotatedSortedArray_precond nums) : Prop :=
  -- !benchmark @start postcond
  result ∈ nums ∧ ∀ x, x ∈ nums → x ≤ result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem FindMaxInRotatedSortedArray_spec_satisfied (nums : List Int)
    (h_precond : FindMaxInRotatedSortedArray_precond nums) :
    FindMaxInRotatedSortedArray_postcond nums
      (FindMaxInRotatedSortedArray nums h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof