-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MergeIntervals_precond (intervals : List (Int × Int)) : Prop :=
  -- !benchmark @start precond
  ∀ iv ∈ intervals, iv.1 < iv.2
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MergeIntervals (intervals : List (Int × Int)) (h_precond : MergeIntervals_precond intervals) : List (Int × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A point x is covered by an interval (a, b) iff a ≤ x ∧ x < b -/
def coveredBy (x : Int) (iv : Int × Int) : Prop := iv.1 ≤ x ∧ x < iv.2

/-- A point is covered by a list of intervals if it is covered by at least one -/
def coveredByList (x : Int) (ivs : List (Int × Int)) : Prop :=
  ∃ iv ∈ ivs, coveredBy x iv

/-- The result intervals are sorted by start -/
def sortedByStart (ivs : List (Int × Int)) : Prop :=
  List.Pairwise (fun a b => a.1 < b.1) ivs

/-- The result intervals are non-overlapping and non-adjacent (gaps between consecutive intervals) -/
def nonOverlapping (ivs : List (Int × Int)) : Prop :=
  List.Pairwise (fun a b => a.2 < b.1) ivs

/-- All intervals in the list are valid (start < end) -/
def allValid (ivs : List (Int × Int)) : Prop :=
  ∀ iv ∈ ivs, iv.1 < iv.2
-- !benchmark @end postcond_aux


@[reducible, simp]
def MergeIntervals_postcond (intervals : List (Int × Int)) (result : List (Int × Int)) (h_precond : MergeIntervals_precond intervals) : Prop :=
  -- !benchmark @start postcond
  -- All result intervals are valid
  allValid result ∧
  -- Result is sorted by start
  sortedByStart result ∧
  -- Result intervals are non-overlapping and non-adjacent
  nonOverlapping result ∧
  -- Coverage equivalence: a point is covered by the input iff covered by the result
  (∀ x : Int, coveredByList x intervals ↔ coveredByList x result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MergeIntervals_spec_satisfied (intervals : List (Int × Int)) (h_precond : MergeIntervals_precond intervals) :
    MergeIntervals_postcond intervals (MergeIntervals intervals h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof