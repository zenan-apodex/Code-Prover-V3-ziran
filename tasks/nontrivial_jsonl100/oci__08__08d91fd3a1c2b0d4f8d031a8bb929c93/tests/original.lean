-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def CustomSort_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def CustomSort (lst : List Int) (h_precond : CustomSort_precond lst) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isPermutation (l1 l2 : List Int) : Prop :=
  ∀ x : Int, l1.count x = l2.count x

def negsSortedDesc (l : List Int) : Prop :=
  ∀ i j : Nat, i < j → j < l.length →
    l[i]! < 0 → l[j]! < 0 →
    (∀ k : Nat, i ≤ k → k ≤ j → l[k]! < 0) →
    l[i]! ≥ l[j]!

def nonNegsSortedAsc (l : List Int) : Prop :=
  ∀ i j : Nat, i < j → j < l.length →
    l[i]! ≥ 0 → l[j]! ≥ 0 →
    (∀ k : Nat, i ≤ k → k ≤ j → l[k]! ≥ 0) →
    l[i]! ≤ l[j]!

def negsBeforeNonNegs (l : List Int) : Prop :=
  ∀ i j : Nat, i < l.length → j < l.length →
    l[i]! ≥ 0 → l[j]! < 0 → j < i
-- !benchmark @end postcond_aux


@[reducible, simp]
def CustomSort_postcond (lst : List Int) (result : List Int) (h_precond : CustomSort_precond lst) : Prop :=
  -- !benchmark @start postcond
  isPermutation lst result ∧
  negsBeforeNonNegs result ∧
  -- Negative part is sorted descending
  (∀ i j : Nat, i < j → j < result.length →
    result[i]! < 0 → result[j]! < 0 →
    result[i]! ≥ result[j]!) ∧
  -- Non-negative part is sorted ascending
  (∀ i j : Nat, i < j → j < result.length →
    result[i]! ≥ 0 → result[j]! ≥ 0 →
    result[i]! ≤ result[j]!)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem CustomSort_spec_satisfied (lst : List Int) (h_precond : CustomSort_precond lst) :
    CustomSort_postcond lst (CustomSort lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof