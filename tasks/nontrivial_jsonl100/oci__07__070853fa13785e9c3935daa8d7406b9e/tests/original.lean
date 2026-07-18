-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MinRemovalsToMakeValid_precond (s : String) : Prop :=
  -- !benchmark @start precond
  ∀ c ∈ s.toList, c = '(' ∨ c = ')'
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MinRemovalsToMakeValid (s : String) (h_precond : MinRemovalsToMakeValid_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list of parens is valid: every prefix has at least as many '(' as ')', and total counts are equal. -/
def isValidParens (cs : List Char) : Prop :=
  (∀ c ∈ cs, c = '(' ∨ c = ')') ∧
  (∀ i, i ≤ cs.length →
    (cs.take i).count ')' ≤ (cs.take i).count '(') ∧
  cs.count '(' = cs.count ')'

/-- `isSubseq sub sup` means `sub` is a subsequence of `sup`. -/
def isSubseq : List Char → List Char → Prop
  | [], _ => True
  | _ , [] => False
  | a :: as, b :: bs =>
    if a = b then isSubseq as bs
    else isSubseq (a :: as) bs
-- !benchmark @end postcond_aux


@[reducible, simp]
def MinRemovalsToMakeValid_postcond (s : String) (result : Int) (h_precond : MinRemovalsToMakeValid_precond s) : Prop :=
  -- !benchmark @start postcond
  let cs := s.toList
  -- result is non-negative
  result ≥ 0 ∧
  -- there exists a valid subsequence of length cs.length - result
  (∃ sub : List Char, isSubseq sub cs ∧ isValidParens sub ∧ sub.length = cs.length - result.toNat) ∧
  -- no valid subsequence can be longer (i.e., result is minimal)
  (∀ sub : List Char, isSubseq sub cs → isValidParens sub → sub.length ≤ cs.length - result.toNat) ∧
  -- result is at most the length of s
  result ≤ cs.length
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MinRemovalsToMakeValid_spec_satisfied (s : String) (h_precond : MinRemovalsToMakeValid_precond s) :
    MinRemovalsToMakeValid_postcond s (MinRemovalsToMakeValid s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof