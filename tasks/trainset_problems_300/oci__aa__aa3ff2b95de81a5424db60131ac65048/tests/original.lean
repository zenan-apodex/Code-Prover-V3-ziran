-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive TreeNode where
  | empty : TreeNode
  | node : Int → TreeNode → TreeNode → TreeNode
deriving Repr, DecidableEq
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MaxDepth_precond (root : TreeNode) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def MaxDepth (root : TreeNode) (h_precond : MaxDepth_precond root) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive IsMaxDepth : TreeNode → Int → Prop where
  | empty :
      IsMaxDepth TreeNode.empty 0
  | node (v : Int) (l r : TreeNode) (dl dr : Int) :
      IsMaxDepth l dl →
      IsMaxDepth r dr →
      IsMaxDepth (TreeNode.node v l r) (max dl dr + 1)
-- !benchmark @end postcond_aux


@[reducible, simp]
def MaxDepth_postcond (root : TreeNode) (result : Int) (h_precond : MaxDepth_precond root) : Prop :=
  -- !benchmark @start postcond
  IsMaxDepth root result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem MaxDepth_spec_satisfied (root : TreeNode) (h_precond : MaxDepth_precond root) :
    MaxDepth_postcond root (MaxDepth root h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof