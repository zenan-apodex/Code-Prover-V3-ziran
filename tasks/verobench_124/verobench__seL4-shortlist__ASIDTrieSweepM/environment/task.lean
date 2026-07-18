/-
  Candidate seL4-style optimization task: ASID trie sweep with stale-mapping cleanup

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over a
  two-level ASID trie (root directory of pool ids, pools of slot
  entries), clearing stale entries while leaving live mappings intact.

  The mechanism: an ASID address space is a two-level trie. The root
  table maps a top-level index to an optional pool id; each pool maps a
  slot index to an optional entry carrying an asid, a `stale` flag, and a
  `mapCount`. `sweepTrieM targets` walks the listed pools and clears
  every slot whose entry is flagged stale, leaving non-stale entries and
  all non-target pools (and the root directory) untouched.
-/
import Mathlib

namespace seL4Cand.ASIDTrieSweepM

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

abbrev RootIdx := Nat
abbrev PoolId := Nat
abbrev SlotIdx := Nat

structure Entry where
  asid : Nat
  stale : Bool
  mapCount : Nat
  deriving DecidableEq, Repr

abbrev RootTable := RootIdx → Option PoolId
abbrev Pools := PoolId → SlotIdx → Option Entry

structure KernelState where
  root : RootTable
  pool : Pools

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- A pool is among the sweep targets. -/
def isTarget (targets : List PoolId) (p : PoolId) : Prop := p ∈ targets

/-- A slot of a pool currently holds a stale entry. -/
def slotStale (s : KernelState) (p : PoolId) (i : SlotIdx) : Prop :=
  ∃ e, s.pool p i = some e ∧ e.stale = true

/-- A slot of a pool currently holds a non-stale (live) entry. -/
def slotLive (s : KernelState) (p : PoolId) (i : SlotIdx) : Prop :=
  ∃ e, s.pool p i = some e ∧ e.stale = false

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def sweepTrieM (targets : List PoolId) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem sweepTrieM_correct (targets : List PoolId) (st : KernelState) :
    (∃ st', (sweepTrieM targets).run st = some ((), st')) ∧
    (∀ st', (sweepTrieM targets).run st = some ((), st') →
      -- Empty target list is the identity.
      (targets = [] → st' = st) ∧
      -- In every swept pool, every stale slot is cleared.
      (∀ p i, isTarget targets p → slotStale st p i → st'.pool p i = none) ∧
      -- In every swept pool, every live slot survives unchanged.
      (∀ p i, isTarget targets p → slotLive st p i → st'.pool p i = st.pool p i) ∧
      -- Frame: pools that are not targets are untouched, slot by slot.
      (∀ p i, ¬ isTarget targets p → st'.pool p i = st.pool p i) ∧
      -- Frame: the root directory table is never modified.
      (st'.root = st.root) ∧
      -- Conservativity: no entry is ever fabricated anywhere; every
      -- output entry was already present (at the same pool/slot).
      (∀ p i e, st'.pool p i = some e → st.pool p i = some e)) ∧
    (∀ s1 s2, (sweepTrieM targets).run st = some ((), s1) → (sweepTrieM targets).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.ASIDTrieSweepM
