-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CreatePersonSentences_precond (person_list : List (List (String × String))) : Prop :=
  -- !benchmark @start precond
  ∀ person ∈ person_list,
    List.Pairwise (fun a b => a.1 ≠ b.1) person ∧
    (∃ name, ("name", name) ∈ person) ∧
    (∃ age, ("age", age) ∈ person) ∧
    (∃ email, ("email", email) ∈ person)
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CreatePersonSentences (person_list : List (List (String × String)))
    (h_precond : CreatePersonSentences_precond person_list) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def CreatePersonSentences_postcond (person_list : List (List (String × String)))
    (result : List String) (h_precond : CreatePersonSentences_precond person_list) : Prop :=
  -- !benchmark @start postcond
  result.length = person_list.length ∧
  ∀ i : Nat, i < person_list.length →
    ∃ name age email,
      ("name", name) ∈ person_list[i]! ∧
      ("age", age) ∈ person_list[i]! ∧
      ("email", email) ∈ person_list[i]! ∧
      result[i]! = name ++ " is " ++ age ++ " years old and can be reached at " ++ email ++ "."
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CreatePersonSentences_spec_satisfied (person_list : List (List (String × String)))
    (h_precond : CreatePersonSentences_precond person_list) :
    CreatePersonSentences_postcond person_list
      (CreatePersonSentences person_list h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof