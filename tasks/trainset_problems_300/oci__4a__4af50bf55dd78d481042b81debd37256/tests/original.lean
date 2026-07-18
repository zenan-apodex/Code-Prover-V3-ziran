-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def parenCount (xs : List Char) (c : Char) : Nat :=
  xs.countP (fun x => x = c)

def BalancedParensList (xs : List Char) : Prop :=
  (∀ n : Nat, n ≤ xs.length →
    parenCount (xs.take n) ')' ≤ parenCount (xs.take n) '(') ∧
  parenCount xs '(' = parenCount xs ')'
-- !benchmark @end precond_aux

@[reducible, simp]
def IsBalancedParentheses_precond (s : String) : Prop :=
  -- !benchmark @start precond
  ∀ c ∈ s.toList, c = '(' ∨ c = ')'
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def IsBalancedParentheses (s : String) (h_precond : IsBalancedParentheses_precond s) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def IsBalancedParentheses_postcond (s : String) (result : Bool)
    (h_precond : IsBalancedParentheses_precond s) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ BalancedParensList s.toList
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem IsBalancedParentheses_spec_satisfied (s : String)
    (h_precond : IsBalancedParentheses_precond s) :
    IsBalancedParentheses_postcond s (IsBalancedParentheses s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof