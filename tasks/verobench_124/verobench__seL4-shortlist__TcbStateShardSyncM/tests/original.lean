/-
  Candidate seL4-style optimization task: per-shard TCB-state cache synchronization

  This benchmark models reconciliation of per-shard TCB-state caches against the
  authoritative master table. The master maps each thread id to its current state
  word (`master : Tid → Nat`). Each shard below `shardBound` caches its own copy
  (`shard : ShardId → Tid → Nat`). A pending invalidation list
  (`dirty : List (ShardId × Tid)`) records the (shard, thread) pairs whose cached
  copy is stale. One sync pass walks the dirty list and, for every entry whose
  shard is in range, overwrites that shard's cached state word with the master
  value; non-dirty cells and out-of-range shards are left alone, the master table
  is read-only, and the dirty list is emptied afterwards. Re-listing the same pair
  is harmless because copying the master value is idempotent.

  Expected solution style: fold over the dirty list applying pointwise function
  updates to `shard`, then clear `dirty`.
-/
import Mathlib

namespace seL4Cand.TcbStateShardSyncM

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

@[simp] theorem KM.ret_run {σ α : Type} (a : α) (s : σ) :
    (KM.ret a).run s = some (a, s) := rfl
@[simp] theorem KM.bind_run {σ α β : Type} (ma : KM σ α) (f : α → KM σ β) (s : σ) :
    (KM.bind ma f).run s =
      (match ma.run s with
       | none => none
       | some (a, s') => (f a).run s') := rfl
@[simp] theorem KM.get_run {σ : Type} (s : σ) : (KM.get).run s = some (s, s) := rfl
@[simp] theorem KM.set_run {σ : Type} (s s' : σ) : (KM.set s).run s' = some ((), s) := rfl
@[simp] theorem KM.modify_run {σ : Type} (f : σ → σ) (s : σ) :
    (KM.modify f).run s = some ((), f s) := rfl

abbrev Tid := Nat
abbrev ShardId := Nat

structure KernelState where
  master : Tid → Nat
  shard : ShardId → Tid → Nat
  dirty : List (ShardId × Tid)
  shardBound : Nat
-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- A (shard, thread) pair is a pending in-range invalidation. -/
def isDirty (st : KernelState) (s : ShardId) (t : Tid) : Prop := (s, t) ∈ st.dirty
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def syncShardsM : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem syncShardsM_correct (st : KernelState) :
    (∃ st', syncShardsM.run st = some ((), st')) ∧
    (∀ st', syncShardsM.run st = some ((), st') →
      -- (a) Dirty in-range cells are synced from the master table.
      (∀ s t, (s, t) ∈ st.dirty → s < st.shardBound → st'.shard s t = st.master t) ∧
      -- (b) Frame: in-range cells that were not dirty are unchanged.
      (∀ s, s < st.shardBound → ∀ t, (s, t) ∉ st.dirty → st'.shard s t = st.shard s t) ∧
      -- (c) Frame: shards at or above the bound are unchanged for every thread.
      (∀ s, st.shardBound ≤ s → ∀ t, st'.shard s t = st.shard s t) ∧
      -- (d) The master table is read-only.
      (∀ t, st'.master t = st.master t) ∧
      -- (e) The dirty list is cleared.
      st'.dirty = [] ∧
      -- (f) The shard bound is unchanged.
      st'.shardBound = st.shardBound) ∧
    (∀ s1 s2, syncShardsM.run st = some ((), s1) → syncShardsM.run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.TcbStateShardSyncM
