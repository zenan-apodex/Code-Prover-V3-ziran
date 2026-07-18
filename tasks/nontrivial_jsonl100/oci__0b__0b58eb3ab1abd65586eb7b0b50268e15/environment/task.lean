-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def MakeBalancedParentheses_precond (s : String) : Prop :=
  -- !benchmark @start precond
  ∀ c ∈ s.toList, c = '(' ∨ c = ')'
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def MakeBalancedParentheses (s : String) (h_precond : MakeBalancedParentheses_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- A list of chars is balanced parentheses: check via a running depth counter. -/
def isBalancedAux : List Char → Int → Bool
  | [], depth => depth == 0
  | c :: cs, depth =>
    if c == '(' then isBalancedAux cs (depth + 1)
    else if c == ')' then (depth > 0) && isBalancedAux cs (depth - 1)
    else false

def isBalanced (t : List Char) : Prop :=
  isBalancedAux t 0 = true

/-- `xs` is a subsequence of `ys` -/
def isSubseq : List Char → List Char → Prop
  | [], _ => True
  | _ , [] => False
  | x :: xs, y :: ys =>
    if x == y then isSubseq xs ys ∨ isSubseq (x :: xs) ys
    else isSubseq (x :: xs) ys

/-- Lexicographic order on lists of Char (strict less-than) -/
def charListLt : List Char → List Char → Prop
  | [], [] => False
  | [], _ :: _ => True
  | _ :: _, [] => False
  | x :: xs, y :: ys =>
    if x.val < y.val then True
    else if x == y then charListLt xs ys
    else False
-- !benchmark @end postcond_aux


@[reducible, simp]
def MakeBalancedParentheses_postcond (s : String) (result : String) (h_precond : MakeBalancedParentheses_precond s) : Prop :=
  -- !benchmark @start postcond
  let rs := result.toList
  let ss := s.toList
  -- result only contains parens
  (∀ c ∈ rs, c = '(' ∨ c = ')') ∧
  -- result is balanced
  isBalanced rs ∧
  -- result is a subsequence of s
  isSubseq rs ss ∧
  -- result has maximum length among balanced subsequences
  (∀ t : List Char, isSubseq t ss → isBalanced t → t.length ≤ rs.length) ∧
  -- result is lexicographically smallest among maximum-length balanced subsequences
  (∀ t : List Char, isSubseq t ss → isBalanced t → t.length = rs.length →
    rs = t ∨ charListLt rs t)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem MakeBalancedParentheses_spec_satisfied (s : String) (h_precond : MakeBalancedParentheses_precond s) :
    MakeBalancedParentheses_postcond s (MakeBalancedParentheses s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof