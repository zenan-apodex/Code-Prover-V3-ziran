-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ClassifyTriangle_precond (a : Int) (b : Int) (c : Float) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def ClassifyTriangle (a : Int) (b : Int) (c : Float)
    (h_precond : ClassifyTriangle_precond a b c) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def TriangleValid (a : Int) (b : Int) (c : Float) : Prop :=
  0 < a ∧
  0 < b ∧
  0 < c ∧
  (Float.ofInt a + Float.ofInt b > c) ∧
  (Float.ofInt a + c > Float.ofInt b) ∧
  (Float.ofInt b + c > Float.ofInt a)
-- !benchmark @end postcond_aux


@[reducible, simp]
def ClassifyTriangle_postcond (a : Int) (b : Int) (c : Float)
    (result : String) (h_precond : ClassifyTriangle_precond a b c) : Prop :=
  -- !benchmark @start postcond
  (result = "Invalid" ↔ ¬ TriangleValid a b c) ∧
  (result = "Equilateral" ↔
    TriangleValid a b c ∧ Float.ofInt a = Float.ofInt b ∧ Float.ofInt b = c) ∧
  (result = "Isosceles" ↔
    TriangleValid a b c ∧
    (Float.ofInt a = Float.ofInt b ∨ Float.ofInt b = c ∨ Float.ofInt a = c) ∧
    ¬ (Float.ofInt a = Float.ofInt b ∧ Float.ofInt b = c)) ∧
  (result = "Scalene" ↔
    TriangleValid a b c ∧
    Float.ofInt a ≠ Float.ofInt b ∧
    Float.ofInt b ≠ c ∧
    Float.ofInt a ≠ c)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem ClassifyTriangle_spec_satisfied (a : Int) (b : Int) (c : Float)
    (h_precond : ClassifyTriangle_precond a b c) :
    ClassifyTriangle_postcond a b c (ClassifyTriangle a b c h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof