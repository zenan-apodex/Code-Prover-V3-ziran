-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
abbrev TupleEntry := Int × String

def groupedValuesForKey (tuples_list : List (Int × String)) (k : Int) : List String :=
  tuples_list.filterMap (fun p => if p.1 = k then some p.2 else none)
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def TuplesToDict_precond (tuples_list : List (Int × String)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def TuplesToDict (tuples_list : List (Int × String))
    (h_precond : TuplesToDict_precond tuples_list) : List (Int × List String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def TuplesToDict_postcond (tuples_list : List (Int × String)) (result : List (Int × List String))
    (h_precond : TuplesToDict_precond tuples_list) : Prop :=
  -- !benchmark @start postcond
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
    ∀ k : Int,
      ((∃ vs : List String, (k, vs) ∈ result) ↔ ∃ v : String, (k, v) ∈ tuples_list) ∧
      ∀ vs : List String, (k, vs) ∈ result → vs = groupedValuesForKey tuples_list k
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem TuplesToDict_spec_satisfied (tuples_list : List (Int × String))
    (h_precond : TuplesToDict_precond tuples_list) :
    TuplesToDict_postcond tuples_list (TuplesToDict tuples_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof