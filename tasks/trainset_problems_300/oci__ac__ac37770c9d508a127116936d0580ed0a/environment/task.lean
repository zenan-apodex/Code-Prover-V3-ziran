-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def fieldValue (book : List (String × String)) (k : String) : Option String :=
  match book with
  | [] => none
  | (k', v) :: rest => if k' = k then some v else fieldValue rest k

def BookKeysUnique (book : List (String × String)) : Prop :=
  List.Pairwise (fun a b => a.1 ≠ b.1) book

def ValidBook (book : List (String × String)) : Prop :=
  BookKeysUnique book ∧
  (∃ t, fieldValue book "title" = some t) ∧
  (∃ a, fieldValue book "author" = some a) ∧
  (∃ y n, fieldValue book "year" = some y ∧ y.toNat? = some n)
-- !benchmark @end precond_aux

@[reducible, simp]
def SortBooksByKey_precond (books : List (List (String × String))) (key : String) : Prop :=
  -- !benchmark @start precond
  (key = "title" ∨ key = "author" ∨ key = "year") ∧
  ∀ book ∈ books, ValidBook book
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def SortBooksByKey (books : List (List (String × String))) (key : String)
    (h_precond : SortBooksByKey_precond (books) (key)) : List (List (String × String)) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def BookLeByKey (key : String) (b₁ b₂ : List (String × String)) : Prop :=
  if key = "year" then
    ∃ y₁ y₂ n₁ n₂,
      fieldValue b₁ "year" = some y₁ ∧
      fieldValue b₂ "year" = some y₂ ∧
      y₁.toNat? = some n₁ ∧
      y₂.toNat? = some n₂ ∧
      n₁ ≤ n₂
  else
    ∃ s₁ s₂,
      fieldValue b₁ key = some s₁ ∧
      fieldValue b₂ key = some s₂ ∧
      s₁ ≤ s₂
-- !benchmark @end postcond_aux


@[reducible, simp]
def SortBooksByKey_postcond (books : List (List (String × String))) (key : String)
    (result : List (List (String × String))) (h_precond : SortBooksByKey_precond (books) (key)) : Prop :=
  -- !benchmark @start postcond
  result.Perm books ∧
  List.Pairwise (BookLeByKey key) result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem SortBooksByKey_spec_satisfied (books : List (List (String × String))) (key : String)
    (h_precond : SortBooksByKey_precond (books) (key)) :
    SortBooksByKey_postcond (books) (key) (SortBooksByKey (books) (key) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof