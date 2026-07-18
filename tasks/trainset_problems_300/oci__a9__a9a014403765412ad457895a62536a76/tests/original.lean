-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SumOfEvens_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SumOfEvens (numbers : List Int) (h_precond : SumOfEvens_precond numbers) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive SumOfEvensRel : List Int → Int → Prop where
  | nil : SumOfEvensRel [] 0
  | cons_even (x : Int) (xs : List Int) (s : Int) :
      x % 2 = 0 →
      SumOfEvensRel xs s →
      SumOfEvensRel (x :: xs) (x + s)
  | cons_odd (x : Int) (xs : List Int) (s : Int) :
      x % 2 ≠ 0 →
      SumOfEvensRel xs s →
      SumOfEvensRel (x :: xs) s
-- !benchmark @end postcond_aux


@[reducible, simp]
def SumOfEvens_postcond (numbers : List Int) (result : Int)
    (h_precond : SumOfEvens_precond numbers) : Prop :=
  -- !benchmark @start postcond
  SumOfEvensRel numbers result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SumOfEvens_spec_satisfied (numbers : List Int)
    (h_precond : SumOfEvens_precond numbers) :
    SumOfEvens_postcond numbers (SumOfEvens numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof