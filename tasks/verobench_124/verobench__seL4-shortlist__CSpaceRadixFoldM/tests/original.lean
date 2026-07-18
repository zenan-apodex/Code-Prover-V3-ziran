/-
  Candidate seL4-style optimization task: CSpace radix tree refold with cached subtree sums

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over a
  binary radix tree carrying a cached subtree sum at every internal
  node, applying a batch of leaf updates and rebuilding the caches so
  that every internal node again caches the exact sum of its subtree.

  The mechanism: a CSpace index is a binary radix tree. Leaves hold a
  natural-number value; internal nodes hold a cached subtree sum plus
  two children. `refoldM upds` applies each update (a root-to-leaf path
  of booleans, `false = left`, and a new leaf value) and then refreshes
  every cache. The reference `applyAll` describes the intended *values*;
  the genuine work is recomputing the caches so `cachesOk` holds.
-/
import Mathlib

namespace seL4Cand.CSpaceRadixFoldM

-- === BEGIN: DEFINITIONS (provided) ===

structure KM (σ α : Type) where
  run : σ → Option (α × σ)

def KM.ret {σ α : Type} (a : α) : KM σ α := ⟨fun s => some (a, s)⟩
def KM.bind {σ α β : Type} (ma : KM σ α) (f : α → KM σ β) : KM σ β :=
  ⟨fun s =>
    match ma.run s with
    | none => none
    | some (a, s') => (f a).run s'⟩
def KM.get {σ : Type} : KM σ σ := ⟨fun s => some (s, s)⟩
def KM.set {σ : Type} (s : σ) : KM σ Unit := ⟨fun _ => some ((), s)⟩
def KM.modify {σ : Type} (f : σ → σ) : KM σ Unit := ⟨fun s => some ((), f s)⟩
def KM.fail {σ α : Type} : KM σ α := ⟨fun _ => none⟩

@[simp] theorem KM.ret_run {σ α : Type} (a : α) (s : σ) : (KM.ret a).run s = some (a, s) := rfl
@[simp] theorem KM.get_run {σ : Type} (s : σ) : (KM.get).run s = some (s, s) := rfl
@[simp] theorem KM.set_run {σ : Type} (s s' : σ) : (KM.set s').run s = some ((), s') := rfl
@[simp] theorem KM.modify_run {σ : Type} (f : σ → σ) (s : σ) : (KM.modify f).run s = some ((), f s) := rfl

inductive RTree where
  | leaf (v : Nat)
  | node (cache : Nat) (l r : RTree)
  deriving Repr

structure KernelState where
  tree : RTree

/-- The true subtree sum (ignores caches). -/
def RTree.sum : RTree → Nat
  | .leaf v => v
  | .node _ l r => l.sum + r.sum

/-- Apply one update along a root-to-leaf path (`false = left`), setting
    the reached leaf to `v`. Caches are left untouched along the way —
    this is a *values-only* reference; callers compare with `sameValues`. -/
def applyUpd : RTree → (List Bool × Nat) → RTree
  | t, ([], v) =>
      match t with
      | .leaf _ => .leaf v
      | .node c l r => .node c (applyUpd l ([], v)) r  -- path ran out at a node: descend-left default
  | .leaf _, (_ :: _, v) => .leaf v  -- path ran out of tree: overwrite leaf
  | .node c l r, (false :: ds, v) => .node c (applyUpd l (ds, v)) r
  | .node c l r, (true :: ds, v) => .node c l (applyUpd r (ds, v))

/-- Reference fold of `applyUpd` over a whole batch. -/
def applyAll (t : RTree) : List (List Bool × Nat) → RTree
  | [] => t
  | u :: us => applyAll (applyUpd t u) us

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- Structural equality that ignores cache fields: two trees agree on
    shape and on all leaf values. -/
def sameValues : RTree → RTree → Prop
  | .leaf a, .leaf b => a = b
  | .node _ l1 r1, .node _ l2 r2 => sameValues l1 l2 ∧ sameValues r1 r2
  | _, _ => False

/-- Every internal node's cache equals the true sum of its subtree. -/
def cachesOk : RTree → Prop
  | .leaf _ => True
  | .node c l r => c = l.sum + r.sum ∧ cachesOk l ∧ cachesOk r

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def refoldM (upds : List (List Bool × Nat)) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem refoldM_correct (upds : List (List Bool × Nat)) (st : KernelState) :
    (∃ st', (refoldM upds).run st = some ((), st')) ∧
    (∀ st', (refoldM upds).run st = some ((), st') →
      -- The output values match the reference fold of `applyUpd`,
      -- ignoring caches.
      (sameValues st'.tree (applyAll st.tree upds)) ∧
      -- The real work: every cache in the output is correct.
      (cachesOk st'.tree) ∧
      -- Empty update list leaves values unchanged (caches may still be
      -- refreshed, hence only `sameValues` is asserted here).
      (upds = [] → sameValues st'.tree st.tree)) ∧
    (∀ s1 s2, (refoldM upds).run st = some ((), s1) → (refoldM upds).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.CSpaceRadixFoldM
