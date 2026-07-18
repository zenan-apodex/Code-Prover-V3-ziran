-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive IntTree where
  | empty : IntTree
  | node : Int → IntTree → IntTree → IntTree
deriving Repr, DecidableEq

def IntTree.AllPositive : IntTree → Prop
  | .empty => True
  | .node v l r => 0 < v ∧ l.AllPositive ∧ r.AllPositive

inductive IsRootToLeafPath : IntTree → List Int → Prop where
  | leaf (v : Int) :
      IsRootToLeafPath (.node v .empty .empty) [v]
  | left (v : Int) (l r : IntTree) (p : List Int) :
      IsRootToLeafPath l p →
      IsRootToLeafPath (.node v l r) (v :: p)
  | right (v : Int) (l r : IntTree) (p : List Int) :
      IsRootToLeafPath r p →
      IsRootToLeafPath (.node v l r) (v :: p)

def pathProduct (xs : List Int) : Int :=
  xs.foldl (· * ·) 1

opaque EncodesTree : String → IntTree → Prop
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MaxProductPath_precond (root : String) : Prop :=
  -- !benchmark @start precond
  ∃ t : IntTree, EncodesTree root t ∧ t.AllPositive ∧ ∃ p, IsRootToLeafPath t p
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def MaxProductPath (root : String) (h_precond : MaxProductPath_precond root) : List Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def MaxProductPath_postcond (root : String) (result : List Int)
    (h_precond : MaxProductPath_precond root) : Prop :=
  -- !benchmark @start postcond
  ∃ t : IntTree,
    EncodesTree root t ∧
    t.AllPositive ∧
    IsRootToLeafPath t result ∧
    ∀ p : List Int, IsRootToLeafPath t p → pathProduct p ≤ pathProduct result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem MaxProductPath_spec_satisfied (root : String)
    (h_precond : MaxProductPath_precond root) :
    MaxProductPath_postcond root (MaxProductPath root h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof