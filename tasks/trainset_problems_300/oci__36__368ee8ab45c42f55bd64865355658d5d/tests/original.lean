-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ProductOfTwoLargestDistinct_precond (numbers : List Int) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def ProductOfTwoLargestDistinct (numbers : List Int)
    (h_precond : ProductOfTwoLargestDistinct_precond numbers) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def ProductOfTwoLargestDistinct_postcond (numbers : List Int) (result : Int)
    (h_precond : ProductOfTwoLargestDistinct_precond numbers) : Prop :=
  -- !benchmark @start postcond
  ( (∀ a ∈ numbers, ∀ b ∈ numbers, a = b) → result = 0 ) ∧
  ( (∃ a ∈ numbers, ∃ b ∈ numbers, a ≠ b) →
      ∃ a ∈ numbers, ∃ b ∈ numbers,
        a ≠ b ∧
        result = a * b ∧
        (∀ x ∈ numbers, x ≤ a) ∧
        (∀ x ∈ numbers, x ≠ a → x ≤ b) )
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem ProductOfTwoLargestDistinct_spec_satisfied (numbers : List Int)
    (h_precond : ProductOfTwoLargestDistinct_precond numbers) :
    ProductOfTwoLargestDistinct_postcond numbers
      (ProductOfTwoLargestDistinct numbers h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof