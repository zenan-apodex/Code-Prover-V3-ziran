-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def AppearsBefore {α : Type} (a b : α) : List α → Prop
  | [] => False
  | x :: xs =>
      x = a ∧ b ∈ xs ∨ AppearsBefore a b xs
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortTuplesBySecondItem_precond (tuples_list : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SortTuplesBySecondItem (tuples_list : List (String × Int))
    (h_precond : SortTuplesBySecondItem_precond tuples_list) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def SortTuplesBySecondItem_postcond (tuples_list : List (String × Int))
    (result : List (String × Int))
    (h_precond : SortTuplesBySecondItem_precond tuples_list) : Prop :=
  -- !benchmark @start postcond
  result.Perm tuples_list ∧
  List.Pairwise (fun a b => a.2 ≤ b.2) result ∧
  ∀ a b : String × Int,
    a.2 = b.2 →
    AppearsBefore a b tuples_list →
    AppearsBefore a b result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SortTuplesBySecondItem_spec_satisfied (tuples_list : List (String × Int))
    (h_precond : SortTuplesBySecondItem_precond tuples_list) :
    SortTuplesBySecondItem_postcond tuples_list
      (SortTuplesBySecondItem tuples_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof