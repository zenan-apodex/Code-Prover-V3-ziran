-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def Intersection_precond (nums1 : List Int) (nums2 : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def Intersection (nums1 : List Int) (nums2 : List Int)
    (h_precond : Intersection_precond nums1 nums2) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def Intersection_postcond (nums1 : List Int) (nums2 : List Int) (result : List Int)
    (h_precond : Intersection_precond nums1 nums2) : Prop :=
  -- !benchmark @start postcond
  result.Nodup ∧
    ∀ x : Int, x ∈ result ↔ x ∈ nums1 ∧ x ∈ nums2
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem Intersection_spec_satisfied (nums1 : List Int) (nums2 : List Int)
    (h_precond : Intersection_precond nums1 nums2) :
    Intersection_postcond nums1 nums2 (Intersection nums1 nums2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof