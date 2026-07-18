-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsPalindrome_precond (num : Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsPalindrome (num : Int) (h_precond : IsPalindrome_precond num) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def DecimalPalindrome (n : Int) : Prop :=
  let ds := toString n |>.toList
  ds = ds.reverse

def IsThreeDigit (n : Int) : Prop :=
  100 ≤ n ∧ n ≤ 999
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsPalindrome_postcond (num : Int) (result : Int) (h_precond : IsPalindrome_precond num) : Prop :=
  -- !benchmark @start postcond
  DecimalPalindrome result ∧
  (∃ a b : Int, IsThreeDigit a ∧ IsThreeDigit b ∧ result = a * b) ∧
  (∀ p : Int,
    DecimalPalindrome p →
    (∃ a b : Int, IsThreeDigit a ∧ IsThreeDigit b ∧ p = a * b) →
    p ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsPalindrome_spec_satisfied (num : Int) (h_precond : IsPalindrome_precond num) :
    IsPalindrome_postcond num (IsPalindrome num h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof