-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def CharacterFrequency_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def CharacterFrequency (s : String) (h_precond : CharacterFrequency_precond s) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsSingletonCharString (w : String) (c : Char) : Prop :=
  w.toList = [c]
-- !benchmark @end postcond_aux


@[reducible, simp]
def CharacterFrequency_postcond (s : String) (result : List (String × Int))
    (h_precond : CharacterFrequency_precond s) : Prop :=
  -- !benchmark @start postcond
  (∀ p ∈ result,
    ∃ c : Char,
      IsSingletonCharString p.1 c ∧
      p.2 = Int.ofNat ((s.toList.filter (· = c)).length)) ∧
  (∀ c ∈ s.toList, ∃ p ∈ result, IsSingletonCharString p.1 c) ∧
  List.Pairwise (fun a b => a.1 ≠ b.1) result ∧
  (∀ p ∈ result, p.2 > 0)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem CharacterFrequency_spec_satisfied (s : String) (h_precond : CharacterFrequency_precond s) :
    CharacterFrequency_postcond s (CharacterFrequency s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof