-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive TreeNode where
  | nil : TreeNode
  | node (val : Int) (left : TreeNode) (right : TreeNode) : TreeNode
deriving Repr, DecidableEq
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsBalanced_precond (root : TreeNode) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
def TreeNode.height : TreeNode → Nat
  | .nil => 0
  | .node _ l r => max l.height r.height + 1

def TreeNode.Balanced : TreeNode → Prop
  | .nil => True
  | .node _ l r =>
      TreeNode.Balanced l ∧
      TreeNode.Balanced r ∧
      Int.natAbs ((l.height : Int) - (r.height : Int)) ≤ 1
-- !benchmark @end code_aux

def IsBalanced (root : TreeNode) (h_precond : IsBalanced_precond root) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def IsBalanced_postcond (root : TreeNode) (result : Bool)
    (h_precond : IsBalanced_precond root) : Prop :=
  -- !benchmark @start postcond
  (result = true ↔ TreeNode.Balanced root) ∧
  (result = false ↔ ¬ TreeNode.Balanced root)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem IsBalanced_spec_satisfied (root : TreeNode)
    (h_precond : IsBalanced_precond root) :
    IsBalanced_postcond root (IsBalanced root h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof