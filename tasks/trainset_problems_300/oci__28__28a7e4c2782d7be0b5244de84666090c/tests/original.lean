-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
inductive BTree where
  | empty : BTree
  | node (value : Int) (left : BTree) (right : BTree) : BTree
deriving Repr, DecidableEq

inductive EncodesTree : String → BTree → Prop where
  | null :
      EncodesTree "null" BTree.empty
  | none :
      EncodesTree "None" BTree.empty
  | leaf (v : Int) :
      EncodesTree ("TreeNode(" ++ toString v ++ ")") (BTree.node v BTree.empty BTree.empty)
  | leftOnly (v : Int) (sl : String) (l : BTree)
      (hl : EncodesTree sl l) (hne : l ≠ BTree.empty) :
      EncodesTree ("TreeNode(" ++ toString v ++ ", " ++ sl ++ ")")
        (BTree.node v l BTree.empty)
  | rightOnly (v : Int) (sr : String) (r : BTree)
      (hr : EncodesTree sr r) (hne : r ≠ BTree.empty) :
      EncodesTree ("TreeNode(" ++ toString v ++ ", None, " ++ sr ++ ")")
        (BTree.node v BTree.empty r)
  | both (v : Int) (sl sr : String) (l r : BTree)
      (hl : EncodesTree sl l) (hr : EncodesTree sr r) :
      EncodesTree ("TreeNode(" ++ toString v ++ ", " ++ sl ++ ", " ++ sr ++ ")")
        (BTree.node v l r)

inductive IsInorderTraversal : BTree → List Int → Prop where
  | empty :
      IsInorderTraversal BTree.empty []
  | node (v : Int) (l r : BTree) (xs ys : List Int)
      (hl : IsInorderTraversal l xs) (hr : IsInorderTraversal r ys) :
      IsInorderTraversal (BTree.node v l r) (xs ++ [v] ++ ys)
-- !benchmark @end precond_aux

@[reducible, simp]
def InorderTraversal_precond (root : String) : Prop :=
  -- !benchmark @start precond
  ∃ t : BTree, EncodesTree root t
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
def InorderTraversal_postcond (root : String) (result : List Int)
    (h_precond : InorderTraversal_precond root) : Prop :=
  -- !benchmark @start postcond
  ∃ t : BTree, EncodesTree root t ∧ IsInorderTraversal t result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem InorderTraversal_spec_satisfied (root : String)
    (h_precond : InorderTraversal_precond root) :
    InorderTraversal_postcond root (InorderTraversal root h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof