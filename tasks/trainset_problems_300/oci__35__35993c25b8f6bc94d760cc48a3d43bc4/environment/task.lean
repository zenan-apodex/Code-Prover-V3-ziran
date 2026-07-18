-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsValidParentheses_precond (s : String) : Prop :=
  -- !benchmark @start precond
  ∀ c ∈ s.toList, c = '(' ∨ c = ')'
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def IsValidParentheses (s : String) (h_precond : IsValidParentheses_precond s) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def PrefixOpenCount (s : String) (n : Nat) : Nat :=
  (s.toList.take n).count '('

def PrefixCloseCount (s : String) (n : Nat) : Nat :=
  (s.toList.take n).count ')'

def ValidParenthesesSequence (s : String) : Prop :=
  s.toList.count '(' = s.toList.count ')' ∧
    ∀ n : Nat, n ≤ s.toList.length →
      PrefixCloseCount s n ≤ PrefixOpenCount s n
-- !benchmark @end postcond_aux

@[reducible, simp]
def IsValidParentheses_postcond (s : String) (result : Bool)
    (h_precond : IsValidParentheses_precond s) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔ ValidParenthesesSequence s
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem IsValidParentheses_spec_satisfied (s : String)
    (h_precond : IsValidParentheses_precond s) :
    IsValidParentheses_postcond s (IsValidParentheses s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof