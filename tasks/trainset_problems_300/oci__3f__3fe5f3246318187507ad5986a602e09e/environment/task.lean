-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive TreeNode where
  | null : TreeNode
  | node (val : Int) (left : TreeNode) (right : TreeNode) : TreeNode
deriving Repr, DecidableEq

def TreeNode.height : TreeNode → Nat
  | .null => 0
  | .node _ l r => Nat.succ (max l.height r.height)

def TreeNode.valuesAtDepth : TreeNode → Nat → List Int
  | .null, _ => []
  | .node v l r, 0 => [v]
  | .node _ l r, d + 1 => l.valuesAtDepth d ++ r.valuesAtDepth d
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def LevelOrder_precond (root : TreeNode) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def LevelOrder (root : TreeNode) (h_precond : LevelOrder_precond root) : List (List Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def LevelOrder_postcond (root : TreeNode) (result : List (List Int))
    (h_precond : LevelOrder_precond root) : Prop :=
  -- !benchmark @start postcond
  result.length = root.height ∧
  ∀ d : Nat, d < result.length → result[d]! = root.valuesAtDepth d
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem LevelOrder_spec_satisfied (root : TreeNode)
    (h_precond : LevelOrder_precond root) :
    LevelOrder_postcond root (LevelOrder root h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof