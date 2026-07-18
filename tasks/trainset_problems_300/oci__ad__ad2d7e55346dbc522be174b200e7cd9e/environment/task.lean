-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
inductive TreeShape where
  | empty : TreeShape
  | node : TreeShape → TreeShape → TreeShape
deriving Repr

def IsDigitChar (c : Char) : Prop :=
  c = '0' ∨ c = '1' ∨ c = '2' ∨ c = '3' ∨ c = '4' ∨
  c = '5' ∨ c = '6' ∨ c = '7' ∨ c = '8' ∨ c = '9'

def IsNatLiteral (s : String) : Prop :=
  s.length > 0 ∧ ∀ c ∈ s.toList, IsDigitChar c

def IsIntLiteral (s : String) : Prop :=
  IsNatLiteral s ∨ ∃ t : String, s = "-" ++ t ∧ IsNatLiteral t

inductive EncodesTree : String → TreeShape → Prop where
  | null :
      EncodesTree "null" TreeShape.empty
  | leaf (v : String) :
      IsIntLiteral v →
      EncodesTree ("TreeNode(" ++ v ++ ")") (TreeShape.node TreeShape.empty TreeShape.empty)
  | leftOnly (v : String) (l : TreeShape) (sl : String) :
      IsIntLiteral v →
      EncodesTree sl l →
      EncodesTree ("TreeNode(" ++ v ++ ", " ++ sl ++ ")") (TreeShape.node l TreeShape.empty)
  | full (v : String) (l r : TreeShape) (sl sr : String) :
      IsIntLiteral v →
      EncodesTree sl l →
      EncodesTree sr r →
      EncodesTree ("TreeNode(" ++ v ++ ", " ++ sl ++ ", " ++ sr ++ ")") (TreeShape.node l r)
-- !benchmark @end precond_aux

@[reducible, simp]
def IsBalanced_precond (root : String) : Prop :=
  -- !benchmark @start precond
  ∃ t : TreeShape, EncodesTree root t
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsBalanced (root : String) (h_precond : IsBalanced_precond root) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def treeHeight : TreeShape → Nat
  | .empty => 0
  | .node l r => Nat.max (treeHeight l) (treeHeight r) + 1

def HeightBalanced : TreeShape → Prop
  | .empty => True
  | .node l r =>
      HeightBalanced l ∧
      HeightBalanced r ∧
      treeHeight l ≤ treeHeight r + 1 ∧
      treeHeight r ≤ treeHeight l + 1
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsBalanced_postcond (root : String) (result : Bool) (h_precond : IsBalanced_precond root) : Prop :=
  -- !benchmark @start postcond
  ∃ t : TreeShape, EncodesTree root t ∧ ((result = true) ↔ HeightBalanced t)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsBalanced_spec_satisfied (root : String) (h_precond : IsBalanced_precond root) :
    IsBalanced_postcond root (IsBalanced root h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof