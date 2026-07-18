-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SortStudentsByGrade_precond (students_grades : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SortStudentsByGrade (students_grades : List (String × Int))
    (h_precond : SortStudentsByGrade_precond students_grades) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def SortStudentsByGrade_postcond (students_grades : List (String × Int))
    (result : List (String × Int))
    (h_precond : SortStudentsByGrade_precond students_grades) : Prop :=
  -- !benchmark @start postcond
  result.Perm students_grades ∧
  List.Pairwise (fun a b => b.2 ≤ a.2) result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SortStudentsByGrade_spec_satisfied (students_grades : List (String × Int))
    (h_precond : SortStudentsByGrade_precond students_grades) :
    SortStudentsByGrade_postcond students_grades
      (SortStudentsByGrade students_grades h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof