/-
  seL4 Haskell Spec Task: cteRevoke on MDB Tree (KM Monad version)

  The Haskell spec models the MDB as a tree of capabilities.
  cteRevoke at a target node removes all its children and their
  sub-trees, returning the pruned tree and the BST of revoked capIds.

  Source: SEL4/Object/CNode.lhs:339-354

  Revoked capIds stored as a BST. The solver must
  build a BST during recursive tree traversal while maintaining BST
  ordering invariant — requiring comparison-based insertion at each node.
-/
import Mathlib

namespace seL4.CteRevoke_HS

-- === BEGIN: DEFINITIONS (provided) ===

/-- Custom sequence type for tree children. -/
inductive Seq (α : Type) where
  | nil : Seq α
  | cons : α → Seq α → Seq α
  deriving Repr

def Seq.mem {α : Type} (a : α) : Seq α → Prop
  | .nil => False
  | .cons x xs => a = x ∨ Seq.mem a xs
def Seq.length {α : Type} : Seq α → Nat
  | .nil => 0
  | .cons _ xs => xs.length + 1
def Seq.append {α : Type} : Seq α → Seq α → Seq α
  | .nil, ys => ys
  | .cons x xs, ys => .cons x (Seq.append xs ys)
instance {α : Type} : Membership α (Seq α) where
  mem s a := @Seq.mem α a s
instance {α : Type} : Append (Seq α) := ⟨@Seq.append α⟩

def Seq.Nodup {α : Type} : Seq α → Prop
  | .nil => True
  | .cons x xs => x ∉ xs ∧ Seq.Nodup xs


/-- BST storing revoked capIds. -/
inductive IdBST where
  | leaf : IdBST
  | node : IdBST → Nat → IdBST → IdBST
  deriving Repr

def IdBST.mem (k : Nat) : IdBST → Prop
  | .leaf => False
  | .node l x r => k = x ∨ IdBST.mem k l ∨ IdBST.mem k r

instance : Membership Nat IdBST where
  mem t k := IdBST.mem k t

def IdBST.All (p : Nat → Prop) : IdBST → Prop
  | .leaf => True
  | .node l x r => p x ∧ IdBST.All p l ∧ IdBST.All p r

def IdBST.Ordered : IdBST → Prop
  | .leaf => True
  | .node l x r =>
    IdBST.All (· < x) l ∧ IdBST.All (x < ·) r ∧
    IdBST.Ordered l ∧ IdBST.Ordered r

def IdBST.NoDup : IdBST → Prop
  | .leaf => True
  | .node l x r => x ∉ l ∧ x ∉ r ∧ IdBST.NoDup l ∧ IdBST.NoDup r

def IdBST.size : IdBST → Nat
  | .leaf => 0
  | .node l _ r => l.size + 1 + r.size

def IdBST.height : IdBST → Nat
  | .leaf => 0
  | .node l _ r => Nat.succ (Nat.max l.height r.height)

def IdBST.Balanced : IdBST → Prop
  | .leaf => True
  | .node l _ r =>
    IdBST.Balanced l ∧ IdBST.Balanced r ∧
    l.height ≤ r.height + 1 ∧ r.height ≤ l.height + 1


/-- MDB modeled as a rose tree of capabilities. -/
inductive CTree where
  | node (capId : Nat) (children : Seq CTree)
  deriving Repr

/-- Collect all capIds in a tree (pre-order DFS). -/
def CTree.allIds : CTree → Seq Nat
  | .node id children => .cons id (allIdsSeq children)
where
  allIdsSeq : Seq CTree → Seq Nat
  | .nil => .nil
  | .cons t ts => CTree.allIds t ++ allIdsSeq ts

/-- Find the sub-tree rooted at a given capId. -/
def CTree.findSubtree : CTree → Nat → Option CTree
  | .node id children, target =>
    if id = target then some (.node id children)
    else findInList children target
where
  findInList : Seq CTree → Nat → Option CTree
  | .nil, _ => none
  | .cons c cs, target =>
    match c.findSubtree target with
    | some r => some r
    | none => findInList cs target

/-- The capIds of all descendants of targetId (NOT including targetId). -/
def descendantsOf (tree : CTree) (targetId : Nat) : Seq Nat :=
  match tree.findSubtree targetId with
  | some (.node _ children) => CTree.allIds.allIdsSeq children
  | none => .nil


/-- Kernel Monad: explicit state + failure. -/
structure KM (σ α : Type) where
  run : σ → Option (α × σ)

def KM.ret {σ α : Type} (a : α) : KM σ α := ⟨fun s => some (a, s)⟩
def KM.bind {σ α β : Type} (ma : KM σ α) (f : α → KM σ β) : KM σ β :=
  ⟨fun s => match ma.run s with | none => none | some (a, s') => (f a).run s'⟩
def KM.get {σ : Type} : KM σ σ := ⟨fun s => some (s, s)⟩
def KM.set {σ : Type} (s : σ) : KM σ Unit := ⟨fun _ => some ((), s)⟩
def KM.fail {σ α : Type} : KM σ α := ⟨fun _ => none⟩


/-- State threaded through the revoke operation.
    `revoked` is now a BST of revoked capIds. -/
structure RevokeState where
  tree : CTree
  revoked : IdBST

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- All capIds in the tree are unique. -/
def uniqueIds (tree : CTree) : Prop :=
  tree.allIds.Nodup

/-- The target node exists and has no children. -/
def targetIsLeaf (tree : CTree) (targetId : Nat) : Prop :=
  tree.findSubtree targetId = some (.node targetId .nil)

/-- All non-descendant nodes are preserved in the result. -/
def nonDescPreserved (before after : CTree) (targetId : Nat) : Prop :=
  ∀ id ∈ before.allIds,
    id ∉ descendantsOf before targetId →
    id ∈ after.allIds

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

/-- Revoke all capabilities derived from the target node.
    Collects revoked capIds into a BST in the state. -/
def cteRevokeM (targetId : Nat) : KM RevokeState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem cteRevokeM_correct (tree₀ : CTree) (targetId : Nat)
    (h_unique : uniqueIds tree₀)
    (h_exists : targetId ∈ tree₀.allIds) :
    let rs₀ : RevokeState := ⟨tree₀, .leaf⟩
    -- The operation does not fail
    (cteRevokeM targetId).run rs₀ ≠ none ∧
    -- For the resulting state rs':
    (∀ rs' : RevokeState,
      (cteRevokeM targetId).run rs₀ = some ((), rs') →
      -- (1) Target becomes a leaf (no children)
      targetIsLeaf rs'.tree targetId ∧
      -- (2) Non-descendants preserved
      nonDescPreserved tree₀ rs'.tree targetId ∧
      -- (3) Revoked BST is ordered
      rs'.revoked.Ordered ∧
      -- (4) Revoked BST has no duplicates
      rs'.revoked.NoDup ∧
      -- (5) Revoked capIds were all in the original tree
      (∀ id, id ∈ rs'.revoked → id ∈ tree₀.allIds) ∧
      -- (6) Every original id is either in the result tree or revoked BST
      (∀ id ∈ tree₀.allIds, id ∈ rs'.tree.allIds ∨ id ∈ rs'.revoked) ∧
      -- (7) Result still has unique IDs
      uniqueIds rs'.tree ∧
      -- (8) No revoked capId remains in the tree
      (∀ id, id ∈ rs'.revoked → id ∉ rs'.tree.allIds) ∧
      -- (9) Target itself is never revoked
      (targetId ∉ rs'.revoked) ∧
      -- (10) Node count: result tree + revoked BST = original
      (rs'.tree.allIds.length + rs'.revoked.size = tree₀.allIds.length) ∧
      -- (11) Anti-degeneration: revoked BST remains balanced.
      rs'.revoked.Balanced ∧
      -- (12) Log-height bound for revoked BST.
      (rs'.revoked.height ≤ Nat.log2 (rs'.revoked.size + 1) + 1) ∧
      -- (13) Idempotence via bind
      (KM.bind (cteRevokeM targetId) (fun _ => cteRevokeM targetId)).run rs₀ =
        (KM.bind (cteRevokeM targetId) (fun _ => KM.ret ())).run rs₀ ∧
      -- (14) Determinism
      ((cteRevokeM targetId).run rs₀ = some ((), rs')) ∧
      -- (15) Revoked-tree size is bounded by original id count.
      rs'.revoked.size ≤ tree₀.allIds.length) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- === END: AUX ===

end seL4.CteRevoke_HS
