-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortEmployeesBySalary_precond (employees : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SortEmployeesBySalary (employees : List (String × Int))
    (h_precond : SortEmployeesBySalary_precond employees) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def SalaryNonIncreasing (xs : List (String × Int)) : Prop :=
  List.Pairwise (fun a b => b.2 ≤ a.2) xs
-- !benchmark @end postcond_aux

@[reducible, simp]
def SortEmployeesBySalary_postcond (employees : List (String × Int))
    (result : List (String × Int))
    (h_precond : SortEmployeesBySalary_precond employees) : Prop :=
  -- !benchmark @start postcond
  result.Perm employees ∧ SalaryNonIncreasing result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SortEmployeesBySalary_spec_satisfied (employees : List (String × Int))
    (h_precond : SortEmployeesBySalary_precond employees) :
    SortEmployeesBySalary_postcond employees
      (SortEmployeesBySalary employees h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof