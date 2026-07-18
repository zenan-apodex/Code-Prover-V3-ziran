-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MaxNonOverlappingIntervals_precond (intervals : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MaxNonOverlappingIntervals (intervals : List (Int × Int)) (h_precond : MaxNonOverlappingIntervals_precond intervals) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list of intervals is pairwise non-overlapping: for every pair (i < j),
    the earlier one in the list ends ≤ the start of the later one. -/
def isNonOverlapping (selected : List (Int × Int)) : Prop :=
  ∀ i j, i < j → j < selected.length →
    (selected[i]!).2 ≤ (selected[j]!).1

/-- Every interval in `selected` appears in `intervals` with correct multiplicity.
    We use `List.Sublist` which preserves order but that's fine — we can always
    reorder a selection to match. Instead we use the weaker: selected is a
    subsequence-preserving sub-multiset. Actually, let's use `List.Subperm`. -/
def isSubMultiset (selected intervals : List (Int × Int)) : Prop :=
  selected.Subperm intervals
-- !benchmark @end postcond_aux


@[reducible, simp]
def MaxNonOverlappingIntervals_postcond (intervals : List (Int × Int)) (result : Int) (h_precond : MaxNonOverlappingIntervals_precond intervals) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  -- There exists a non-overlapping selection of size `result`
  (∃ selected : List (Int × Int),
    isSubMultiset selected intervals ∧
    -- selected is sorted by end time (which implies we can check non-overlapping pairwise adjacently)
    (∀ i, i + 1 < selected.length → (selected[i]!).2 ≤ (selected[i + 1]!).1) ∧
    selected.length = result.toNat) ∧
  -- No non-overlapping selection can have more than `result` intervals
  (∀ selected : List (Int × Int),
    isSubMultiset selected intervals →
    isNonOverlapping selected →
    selected.length ≤ result.toNat)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MaxNonOverlappingIntervals_spec_satisfied (intervals : List (Int × Int)) (h_precond : MaxNonOverlappingIntervals_precond intervals) :
    MaxNonOverlappingIntervals_postcond intervals (MaxNonOverlappingIntervals intervals h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof