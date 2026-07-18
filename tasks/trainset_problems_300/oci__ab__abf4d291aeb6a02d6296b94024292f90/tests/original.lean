-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
inductive BinTree where
  | empty : BinTree
  | node : Int → BinTree → BinTree → BinTree
deriving Repr

inductive EncodesTree : String → BinTree → Prop where
  | null :
      EncodesTree "null" BinTree.empty
  | none :
      EncodesTree "None" BinTree.empty
  | leaf (v : Int) :
      EncodesTree s (BinTree.node v BinTree.empty BinTree.empty) →
      s = "TreeNode(" ++ toString v ++ ")" →
      EncodesTree s (BinTree.node v BinTree.empty BinTree.empty)
  | node_full (v : Int) (l r : BinTree) (sl sr s : String) :
      EncodesTree sl l →
      EncodesTree sr r →
      s = "TreeNode(" ++ toString v ++ ", " ++ sl ++ ", " ++ sr ++ ")" →
      EncodesTree s (BinTree.node v l r)
  | node_left_only (v : Int) (l : BinTree) (sl s : String) :
      EncodesTree sl l →
      s = "TreeNode(" ++ toString v ++ ", " ++ sl ++ ")" →
      EncodesTree s (BinTree.node v l BinTree.empty)

def IsInorderTraversal : BinTree → List Int → Prop
  | BinTree.empty, xs => xs = []
  | BinTree.node v l r, xs =>
      ∃ xl xr,
        IsInorderTraversal l xl ∧
        IsInorderTraversal r xr ∧
        xs = xl ++ [v] ++ xr
-- !benchmark @end precond_aux

@[reducible, simp]
def InorderTraversal_precond (root : String) : Prop :=
  -- !benchmark @start precond
  ∃ t : BinTree, EncodesTree root t
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def InorderTraversal (root : String) (h_precond : InorderTraversal_precond root) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def InorderTraversal_postcond (root : String) (result : List Int) (h_precond : InorderTraversal_precond root) : Prop :=
  -- !benchmark @start postcond
  ∃ t : BinTree, EncodesTree root t ∧ IsInorderTraversal t result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem InorderTraversal_spec_satisfied (root : String) (h_precond : InorderTraversal_precond root) :
    InorderTraversal_postcond root (InorderTraversal root h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof