/-
  seL4 Optimization Task: EP reorder (MCS) — priority-indexed thread BSTs
  Source: src/object/endpoint.c, src/object/sched.c

  Per-priority thread queues stored as BSTs. Enqueue =
  BST insert, dequeue = BST delete. The solver must implement BST
  operations and prove ordering invariant preservation through all
  four operations (enqueue, dequeue, reorder, migrate).
-/
import Mathlib

namespace seL4.EPReorderMCS

-- === BEGIN: DEFINITIONS (provided) ===

abbrev Tid := Nat
abbrev Priority := Fin 256

/-- BST storing thread ids per priority level. -/
inductive TidBST where
  | leaf : TidBST
  | node : TidBST → Tid → TidBST → TidBST
  deriving Repr

def TidBST.mem (k : Nat) : TidBST → Prop
  | .leaf => False
  | .node l x r => k = x ∨ TidBST.mem k l ∨ TidBST.mem k r

instance : Membership Nat TidBST where
  mem t k := TidBST.mem k t

def TidBST.All (p : Nat → Prop) : TidBST → Prop
  | .leaf => True
  | .node l x r => p x ∧ TidBST.All p l ∧ TidBST.All p r

def TidBST.Ordered : TidBST → Prop
  | .leaf => True
  | .node l x r =>
    TidBST.All (· < x) l ∧ TidBST.All (x < ·) r ∧
    TidBST.Ordered l ∧ TidBST.Ordered r

def TidBST.NoDup : TidBST → Prop
  | .leaf => True
  | .node l x r => x ∉ l ∧ x ∉ r ∧ TidBST.NoDup l ∧ TidBST.NoDup r

def TidBST.size : TidBST → Nat
  | .leaf => 0
  | .node l _ r => l.size + 1 + r.size

def TidBST.height : TidBST → Nat
  | .leaf => 0
  | .node l _ r => Nat.succ (Nat.max l.height r.height)

def TidBST.Balanced : TidBST → Prop
  | .leaf => True
  | .node l _ r =>
    TidBST.Balanced l ∧ TidBST.Balanced r ∧
    l.height ≤ r.height + 1 ∧ r.height ≤ l.height + 1

/-- Priority queues: one BST per priority level. -/
abbrev PrioQueues := Priority → TidBST

/-- Kernel monad. -/
structure KM (σ α : Type) where
  run : σ → Option (α × σ)

def KM.ret {σ α : Type} (a : α) : KM σ α := ⟨fun s => some (a, s)⟩
def KM.bind {σ α β : Type} (ma : KM σ α) (f : α → KM σ β) : KM σ β :=
  ⟨fun s => match ma.run s with
    | none => none
    | some (a, s') => (f a).run s'⟩
def KM.get {σ : Type} : KM σ σ := ⟨fun s => some (s, s)⟩
def KM.set {σ : Type} (s : σ) : KM σ Unit := ⟨fun _ => some ((), s)⟩
def KM.fail {σ α : Type} : KM σ α := ⟨fun _ => none⟩

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- A tid is at a specific priority. -/
def threadAt (pqs : PrioQueues) (tid : Tid) (p : Priority) : Prop :=
  tid ∈ pqs p

/-- Each thread id appears in at most one priority level. -/
def uniqueAcross (pqs : PrioQueues) : Prop :=
  ∀ (p₁ p₂ : Priority) (tid : Tid),
    threadAt pqs tid p₁ → threadAt pqs tid p₂ → p₁ = p₂

/-- All BSTs are ordered. -/
def allOrdered (pqs : PrioQueues) : Prop :=
  ∀ p, (pqs p).Ordered

/-- All BSTs have no duplicates. -/
def allNoDup (pqs : PrioQueues) : Prop :=
  ∀ p, (pqs p).NoDup

/-- All BSTs are height-balanced. -/
def allBalanced (pqs : PrioQueues) : Prop :=
  ∀ p, (pqs p).Balanced

/-- All BST heights satisfy a logarithmic bound. -/
def allLogBound (pqs : PrioQueues) : Prop :=
  ∀ p, (pqs p).height ≤ Nat.log2 ((pqs p).size + 1) + 1

/-- Well-formed: unique across + ordered + nodup + anti-degeneration. -/
def wellFormed (pqs : PrioQueues) : Prop :=
  uniqueAcross pqs ∧ allOrdered pqs ∧ allNoDup pqs ∧ allBalanced pqs ∧ allLogBound pqs

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

/-- Insert tid into BST at priority p. -/
def enqueueM (tid : Tid) (p : Priority) : KM PrioQueues Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry

/-- Remove tid from wherever it lives. -/
def dequeueM (tid : Tid) : KM PrioQueues Unit :=
  sorry

/-- Move tid from oldPrio to newPrio. -/
def reorderM (tid : Tid) (oldPrio newPrio : Priority) : KM PrioQueues Unit :=
  sorry

/-- Move all threads from srcPrio to dstPrio. -/
def migrateM (srcPrio dstPrio : Priority) : KM PrioQueues Unit :=
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem epReorder_correct :
    -- (1) All operations preserve wellFormed.
    (∀ pqs tid p, wellFormed pqs →
      (∀ p', ¬ threadAt pqs tid p') →
      ∀ pqs', (enqueueM tid p).run pqs = some ((), pqs') →
      wellFormed pqs') ∧
    (∀ pqs tid, wellFormed pqs →
      ∀ pqs', (dequeueM tid).run pqs = some ((), pqs') →
      wellFormed pqs') ∧
    (∀ pqs tid oldP newP, wellFormed pqs →
      threadAt pqs tid oldP →
      ∀ pqs', (reorderM tid oldP newP).run pqs = some ((), pqs') →
      wellFormed pqs') ∧
    (∀ pqs srcP dstP, wellFormed pqs →
      srcP ≠ dstP →
      ∀ pqs', (migrateM srcP dstP).run pqs = some ((), pqs') →
      wellFormed pqs') ∧
    -- (2) enqueueM non-failure.
    (∀ pqs tid p, wellFormed pqs →
      (∀ p', ¬ threadAt pqs tid p') →
      (enqueueM tid p).run pqs ≠ none) ∧
    -- (3) enqueueM membership.
    (∀ pqs tid p, wellFormed pqs →
      (∀ p', ¬ threadAt pqs tid p') →
      ∀ pqs', (enqueueM tid p).run pqs = some ((), pqs') →
      threadAt pqs' tid p ∧
      (∀ tid', tid' ≠ tid → (threadAt pqs' tid' p ↔ threadAt pqs tid' p)) ∧
      (∀ p', p' ≠ p → pqs' p' = pqs p')) ∧
    -- (4) dequeueM non-failure.
    (∀ pqs tid, wellFormed pqs →
      (dequeueM tid).run pqs ≠ none) ∧
    -- (5) dequeueM membership.
    (∀ pqs tid, wellFormed pqs →
      ∀ pqs', (dequeueM tid).run pqs = some ((), pqs') →
      (∀ p, ¬ threadAt pqs' tid p) ∧
      (∀ p tid', tid' ≠ tid → (threadAt pqs' tid' p ↔ threadAt pqs tid' p))) ∧
    -- (6) dequeueM ∘ enqueueM = id on fresh tid.
    (∀ pqs tid p, wellFormed pqs →
      (∀ p', ¬ threadAt pqs tid p') →
      (KM.bind (enqueueM tid p) (fun _ => dequeueM tid)).run pqs =
        some ((), pqs)) ∧
    -- (7) reorderM semantics.
    (∀ pqs tid oldP newP, wellFormed pqs →
      threadAt pqs tid oldP →
      ∀ pqs', (reorderM tid oldP newP).run pqs = some ((), pqs') →
      threadAt pqs' tid newP ∧
      (∀ tid', tid' ≠ tid → ∀ p, threadAt pqs' tid' p ↔ threadAt pqs tid' p)) ∧
    -- (8) migrateM membership.
    (∀ pqs srcP dstP, wellFormed pqs →
      srcP ≠ dstP →
      ∀ pqs', (migrateM srcP dstP).run pqs = some ((), pqs') →
      (∀ tid, ¬ threadAt pqs' tid srcP) ∧
      (∀ tid, threadAt pqs' tid dstP ↔
        threadAt pqs tid dstP ∨ threadAt pqs tid srcP) ∧
      (∀ p, p ≠ srcP → p ≠ dstP → pqs' p = pqs p)) ∧
    -- (9) migrateM non-failure.
    (∀ pqs srcP dstP, wellFormed pqs →
      srcP ≠ dstP →
      (migrateM srcP dstP).run pqs ≠ none) ∧
    -- (10) Self-migrate is identity.
    (∀ pqs p, wellFormed pqs →
      (migrateM p p).run pqs = some ((), pqs)) ∧
    -- (11) reorderM to same priority preserves.
    (∀ pqs tid p, wellFormed pqs →
      threadAt pqs tid p →
      ∀ pqs', (reorderM tid p p).run pqs = some ((), pqs') →
      threadAt pqs' tid p ∧
      (∀ tid', tid' ≠ tid → (threadAt pqs' tid' p ↔ threadAt pqs tid' p))) ∧
    -- (12) Determinism: enqueueM.
    (∀ pqs tid p pqs₁ pqs₂,
      (enqueueM tid p).run pqs = some ((), pqs₁) →
      (enqueueM tid p).run pqs = some ((), pqs₂) → pqs₁ = pqs₂) ∧
    -- (13) Determinism: dequeueM.
    (∀ pqs tid pqs₁ pqs₂,
      (dequeueM tid).run pqs = some ((), pqs₁) →
      (dequeueM tid).run pqs = some ((), pqs₂) → pqs₁ = pqs₂) ∧
    -- (14) Determinism: reorderM.
    (∀ pqs tid oldP newP s₁ s₂,
      (reorderM tid oldP newP).run pqs = some ((), s₁) →
      (reorderM tid oldP newP).run pqs = some ((), s₂) →
      s₁ = s₂) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- === END: AUX ===

end seL4.EPReorderMCS
