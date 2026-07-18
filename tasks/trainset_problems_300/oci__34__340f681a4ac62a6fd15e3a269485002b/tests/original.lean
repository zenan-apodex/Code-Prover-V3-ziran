-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive SumEvenNumbersRel : List Int → Int → Prop where
  | nil : SumEvenNumbersRel [] 0
  | cons_even (x : Int) (xs : List Int) (s : Int) :
      x % 2 = 0 →
      SumEvenNumbersRel xs s →
      SumEvenNumbersRel (x :: xs) (x + s)
  | cons_odd (x : Int) (xs : List Int) (s : Int) :
      x % 2 ≠ 0 →
      SumEvenNumbersRel xs s →
      SumEvenNumbersRel (x :: xs) s
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SumEvenNumbers_precond (lst : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SumEvenNumbers (lst : List Int) (h_precond : SumEvenNumbers_precond lst) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def SumEvenNumbers_postcond (lst : List Int) (result : Int)
    (h_precond : SumEvenNumbers_precond lst) : Prop :=
  -- !benchmark @start postcond
  SumEvenNumbersRel lst result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SumEvenNumbers_spec_satisfied (lst : List Int)
    (h_precond : SumEvenNumbers_precond lst) :
    SumEvenNumbers_postcond lst (SumEvenNumbers lst h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof