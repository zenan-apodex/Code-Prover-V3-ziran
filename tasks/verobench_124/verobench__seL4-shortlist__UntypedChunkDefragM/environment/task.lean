/-
  Candidate seL4-style optimization task: untyped chunk defragmentation with interval coalescing

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over
  slot maps, parent links, free lists, and coverage metadata.
-/
import Mathlib

namespace seL4Cand.UntypedChunkDefragM

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
def KM.fail {σ α : Type} : KM σ α := ⟨fun _ => none⟩

abbrev SlotId := Nat
abbrev CapId := Nat
abbrev Ptr := Nat

structure CapEntry where
  cap : CapId
  guard : Nat
  span : Nat
  deriving DecidableEq, Repr

abbrev SlotMap := SlotId → Option CapEntry
abbrev Parent := SlotId → Option SlotId
abbrev FreeList := List SlotId
abbrev Coverage := SlotId → List Ptr

structure KernelState where
  slots : SlotMap
  parent : Parent
  free : FreeList
  cover : Coverage
  epoch : Nat

inductive Op where
  | install (slot cap guard span : Nat)
  | reparent (slot dst : Nat)
  | coalesce (dst src : Nat)
  | reserve (slot : Nat)
  | release (slot : Nat)
  deriving DecidableEq, Repr
-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

def slotLive (s : KernelState) (slot : SlotId) : Prop := ∃ e, s.slots slot = some e

def spanPositive (s : KernelState) : Prop := ∀ slot e, s.slots slot = some e → e.span > 0

def opCost : Op → Nat
  | .install _ _ g span => g + span + 1
  | .reparent _ _ => 2
  | .coalesce _ _ => 3
  | .reserve _ => 1
  | .release _ => 1

def batchCost : List Op → Nat := List.foldl (fun acc op => acc + opCost op) 0

def installsAt (ops : List Op) (slot cap guard span : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .install slot cap guard span

def reparentsTo (ops : List Op) (slot dst : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .reparent slot dst

def coalescesPair (ops : List Op) (dst src : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .coalesce dst src

def reservesSlot (ops : List Op) (slot : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .reserve slot

def releasesSlot (ops : List Op) (slot : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .release slot

def untouchedSlot (ops : List Op) (slot : Nat) : Prop :=
  ¬(∃ cap g span, installsAt ops slot cap g span) ∧ ¬releasesSlot ops slot ∧ ¬reservesSlot ops slot

/-- Conflict-free `ops`: no two operations target the same slot in
    mutually contradictory ways. Required to make the post-conditions
    of `defragChunksM_correct` simultaneously satisfiable. -/
def noConflictingOps (ops : List Op) : Prop :=
  (∀ slot c1 g1 s1 c2 g2 s2,
      installsAt ops slot c1 g1 s1 → installsAt ops slot c2 g2 s2 →
      c1 = c2 ∧ g1 = g2 ∧ s1 = s2) ∧
  (∀ slot cap guard span, installsAt ops slot cap guard span → span > 0) ∧
  (∀ slot cap guard span, installsAt ops slot cap guard span → ¬releasesSlot ops slot) ∧
  (∀ slot, releasesSlot ops slot → ¬reservesSlot ops slot) ∧
  (∀ slot d1 d2, reparentsTo ops slot d1 → reparentsTo ops slot d2 → d1 = d2)
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- no axioms
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def defragChunksM (ops : List Op) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem defragChunksM_correct (ops : List Op) (st : KernelState)
    (h_span : spanPositive st)
    (h_noconfl : noConflictingOps ops) :
    (∃ st', (defragChunksM ops).run st = some ((), st')) ∧
    (∀ st', (defragChunksM ops).run st = some ((), st') →
      spanPositive st' ∧
      (ops = [] → st' = st) ∧
      (∀ slot, untouchedSlot ops slot → st'.slots slot = st.slots slot) ∧
      (∀ slot cap guard span, installsAt ops slot cap guard span → st'.slots slot = some ⟨cap, guard, span⟩) ∧
      (∀ slot dst, reparentsTo ops slot dst → st'.parent slot = some dst) ∧
      (∀ dst src, coalescesPair ops dst src → ∀ p, p ∈ st.cover src → p ∈ st'.cover dst) ∧
      (∀ slot, releasesSlot ops slot → slot ∈ st'.free ∧ st'.slots slot = none) ∧
      (∀ slot, reservesSlot ops slot → slot ∉ st'.free) ∧
      (batchCost ops > 0 → st'.epoch > st.epoch)) ∧
    (∀ s1 s2, (defragChunksM ops).run st = some ((), s1) → (defragChunksM ops).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- helper lemmas
-- === END: AUX ===

end seL4Cand.UntypedChunkDefragM
