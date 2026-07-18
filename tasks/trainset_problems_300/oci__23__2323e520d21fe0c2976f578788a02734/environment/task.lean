-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SeparateEvenOdd_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SeparateEvenOdd (numbers : List Int) (h_precond : SeparateEvenOdd_precond numbers) :
    List (String × List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive SeparatesEvenOddLists : List Int → List Int → List Int → Prop where
  | nil : SeparatesEvenOddLists [] [] []
  | even {x : Int} {xs evens odds : List Int} :
      x % 2 = 0 →
      SeparatesEvenOddLists xs evens odds →
      SeparatesEvenOddLists (x :: xs) (x :: evens) odds
  | odd {x : Int} {xs evens odds : List Int} :
      x % 2 ≠ 0 →
      SeparatesEvenOddLists xs evens odds →
      SeparatesEvenOddLists (x :: xs) evens (x :: odds)
-- !benchmark @end postcond_aux


@[reducible, simp]
def SeparateEvenOdd_postcond (numbers : List Int) (result : List (String × List Int))
    (h_precond : SeparateEvenOdd_precond numbers) : Prop :=
  -- !benchmark @start postcond
  ∃ evens odds,
    SeparatesEvenOddLists numbers evens odds ∧
    result.Perm [("even", evens), ("odd", odds)] ∧
    List.Pairwise (fun a b => a.1 ≠ b.1) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SeparateEvenOdd_spec_satisfied (numbers : List Int)
    (h_precond : SeparateEvenOdd_precond numbers) :
    SeparateEvenOdd_postcond numbers (SeparateEvenOdd numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof