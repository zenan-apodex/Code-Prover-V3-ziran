-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CountWords_precond (word_list : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CountWords (word_list : List String) (h_precond : CountWords_precond word_list) :
    List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def CountWords_postcond (word_list : List String) (result : List (String × Int))
    (h_precond : CountWords_precond word_list) : Prop :=
  -- !benchmark @start postcond
  (∀ p ∈ result, p.2 = Int.ofNat ((word_list.filter (· = p.1)).length)) ∧
  (∀ w ∈ word_list, ∃ p ∈ result, p.1 = w) ∧
  (∀ p ∈ result, p.1 ∈ word_list) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  (∀ p ∈ result, p.2 > 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CountWords_spec_satisfied (word_list : List String)
    (h_precond : CountWords_precond word_list) :
    CountWords_postcond word_list (CountWords word_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof