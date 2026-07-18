/-
  Candidate seL4-style optimization task: capability-graph pruning by ancestor cut

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over a
  capability derivation graph (parent links plus a liveness bitmap),
  killing every node whose ancestor chain reaches a cut point.

  The mechanism: a capability graph stores a partial `parent` map and a
  `live` bit per node, with a `bound` delimiting the meaningful node ids.
  `pruneGraphM cut` marks dead every node (below the bound) whose chain
  of ancestors — itself, its parent, grandparent, ... — meets one of the
  cut nodes, while leaving the parent structure and the bound intact.
-/
import Mathlib

namespace seL4Cand.CapGraphPruneM

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

abbrev NodeId := Nat

abbrev ParentMap := NodeId → Option NodeId
abbrev LiveMap := NodeId → Bool

structure KernelState where
  parent : ParentMap
  live : LiveMap
  bound : Nat

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- `Reaches st a b`: starting at `a` and following `parent` links zero or
    more times one arrives at `b`. Reflexive (every node reaches itself)
    and closed under one parent step. -/
inductive Reaches (st : KernelState) : NodeId → NodeId → Prop where
  | refl (a : NodeId) : Reaches st a a
  | step (a m b : NodeId) : st.parent a = some m → Reaches st m b → Reaches st a b

/-- Node `n` has a cut node somewhere on its ancestor chain (including
    `n` itself). -/
def hasCutAncestor (st : KernelState) (cut : List NodeId) (n : NodeId) : Prop :=
  ∃ c, c ∈ cut ∧ Reaches st n c

/-- Capability-derivation well-formedness: a parent always has a strictly
    smaller node id. This is the standard MDB/derivation-tree invariant
    (children are created after, and below, their parents); it makes every
    ancestor chain finite (length bounded by the node id), so an honest
    implementation can resolve `hasCutAncestor` by a terminating parent walk. -/
def WellFormed (st : KernelState) : Prop :=
  ∀ n m, st.parent n = some m → m < n

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def pruneGraphM (cut : List NodeId) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem pruneGraphM_correct (cut : List NodeId) (st : KernelState)
    (h_wf : WellFormed st) :
    (∃ st', (pruneGraphM cut).run st = some ((), st')) ∧
    (∀ st', (pruneGraphM cut).run st = some ((), st') →
      -- Empty cut is the identity.
      (cut = [] → st' = st) ∧
      -- Every in-bounds node whose ancestor chain meets the cut dies.
      (∀ n, n < st.bound → hasCutAncestor st cut n → st'.live n = false) ∧
      -- Every in-bounds node with no cut ancestor keeps its live bit.
      (∀ n, n < st.bound → ¬ hasCutAncestor st cut n → st'.live n = st.live n) ∧
      -- Frame: the parent map is never modified.
      (st'.parent = st.parent) ∧
      -- Frame: the bound is never modified.
      (st'.bound = st.bound)) ∧
    (∀ s1 s2, (pruneGraphM cut).run st = some ((), s1) → (pruneGraphM cut).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.CapGraphPruneM
