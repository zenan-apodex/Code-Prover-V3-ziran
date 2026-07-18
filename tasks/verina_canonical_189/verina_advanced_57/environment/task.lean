-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def nextGreaterElement_precond (nums1 : List Int) (nums2 : List Int) : Prop :=
  -- !benchmark @start precond
  List.Nodup nums1 ∧
  List.Nodup nums2 ∧
  nums1.all (fun x => x ∈ nums2)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def nextGreaterElement (nums1 : List Int) (nums2 : List Int) (h_precond : nextGreaterElement_precond (nums1) (nums2)) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def nextGreaterElement_postcond (nums1 : List Int) (nums2 : List Int) (result: List Int) (h_precond : nextGreaterElement_precond (nums1) (nums2)) : Prop :=
  -- !benchmark @start postcond
  result.length = nums1.length ∧

  (List.range nums1.length |>.all (fun i =>
    let val := nums1[i]!
    let resultVal := result[i]!

    let j := nums2.findIdx? (fun x => x == val)
    match j with
    | none => false
    | some idx =>
      let nextGreater := (List.range (nums2.length - idx - 1)).find? (fun k =>
        let pos := idx + k + 1
        nums2[pos]! > val
      )

      match nextGreater with
      | none => resultVal = -1
      | some offset => resultVal = nums2[idx + offset + 1]!
  )) ∧
  (result.all (fun val =>
    val = -1 ∨ val ∈ nums2
  ))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem nextGreaterElement_spec_satisfied (nums1: List Int) (nums2: List Int) (h_precond : nextGreaterElement_precond (nums1) (nums2)) :
    nextGreaterElement_postcond (nums1) (nums2) (nextGreaterElement (nums1) (nums2) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


