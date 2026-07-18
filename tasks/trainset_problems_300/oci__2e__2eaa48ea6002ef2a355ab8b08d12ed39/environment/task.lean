-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def StringFrequencies_precond (strings : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def StringFrequencies (strings : List String) (h_precond : StringFrequencies_precond strings) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def StringFrequencies_postcond (strings : List String) (result : List (String × Int))
    (h_precond : StringFrequencies_precond strings) : Prop :=
  -- !benchmark @start postcond
  (∀ p ∈ result, p.2 = Int.ofNat ((strings.filter (· = p.1)).length)) ∧
  (∀ s ∈ strings, ∃ p ∈ result, p.1 = s) ∧
  (∀ p ∈ result, p.1 ∈ strings) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  (∀ p ∈ result, p.2 > 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem StringFrequencies_spec_satisfied (strings : List String)
    (h_precond : StringFrequencies_precond strings) :
    StringFrequencies_postcond strings (StringFrequencies strings h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof