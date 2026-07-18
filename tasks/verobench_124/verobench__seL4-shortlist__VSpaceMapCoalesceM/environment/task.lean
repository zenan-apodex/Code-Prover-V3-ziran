/-
  Candidate seL4-style optimization task: vspace mapping coalescing

  This benchmark models a virtual-address-space mapping table as a list of
  intervals. Each interval maps a contiguous run of `len` virtual addresses
  starting at `va` onto a contiguous run of physical addresses starting at
  `pa`. The table is kept sorted by virtual address and the virtual ranges are
  pairwise disjoint. Two adjacent intervals are "mergeable" when the second
  begins exactly where the first ends, both virtually and physically; such a
  pair describes one larger contiguous mapping and can be coalesced into a
  single interval. The optimization repeatedly coalesces mergeable neighbours
  so that no mergeable pair remains, while the address translation function is
  preserved exactly.

  Expected solution style: a single left-to-right pass that merges runs of
  mergeable intervals.
-/
import Mathlib

namespace seL4Cand.VSpaceMapCoalesceM

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

@[simp] theorem KM.ret_run {σ α : Type} (a : α) (s : σ) :
    (KM.ret a).run s = some (a, s) := rfl
@[simp] theorem KM.get_run {σ : Type} (s : σ) :
    (KM.get).run s = some (s, s) := rfl
@[simp] theorem KM.set_run {σ : Type} (s s' : σ) :
    (KM.set s').run s = some ((), s') := rfl

def KM.modify {σ : Type} (f : σ → σ) : KM σ Unit := ⟨fun s => some ((), f s)⟩
@[simp] theorem KM.modify_run {σ : Type} (f : σ → σ) (s : σ) :
    (KM.modify f).run s = some ((), f s) := rfl

structure Iv where
  va : Nat
  len : Nat
  pa : Nat
  deriving DecidableEq, Repr

structure KernelState where
  maps : List Iv

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- Translate a virtual address: the first interval containing it wins. -/
def translate : List Iv → Nat → Option Nat
  | [], _ => none
  | iv :: tl, a =>
      if iv.va ≤ a ∧ a < iv.va + iv.len then some (iv.pa + (a - iv.va))
      else translate tl a

/-- Two adjacent intervals are mergeable when the second continues the first
    contiguously in both virtual and physical address. -/
def mergeable : Iv → Iv → Bool :=
  fun a b => (a.va + a.len == b.va) && (a.pa + a.len == b.pa)

/-- All intervals have positive length. -/
def allPos : List Iv → Prop
  | [] => True
  | iv :: tl => iv.len > 0 ∧ allPos tl

/-- The table is sorted by virtual address and the virtual ranges are pairwise
    disjoint: each interval ends no later than the next one begins. -/
def sortedDisjoint : List Iv → Prop
  | [] => True
  | [_] => True
  | a :: b :: tl => a.va + a.len ≤ b.va ∧ sortedDisjoint (b :: tl)

/-- Well-formed mapping table. -/
def WellFormed (m : List Iv) : Prop := allPos m ∧ sortedDisjoint m

/-- No adjacent mergeable pair remains. -/
def noMergeablePair : List Iv → Prop
  | [] => True
  | [_] => True
  | a :: b :: tl => mergeable a b = false ∧ noMergeablePair (b :: tl)

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def coalesceM : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem coalesceM_correct (st : KernelState)
    (h_wf : WellFormed st.maps) :
    (∃ st', coalesceM.run st = some ((), st')) ∧
    (∀ st', coalesceM.run st = some ((), st') →
      -- (a) the translation function is preserved exactly.
      (∀ a, translate st'.maps a = translate st.maps a) ∧
      -- (b) the output is fully coalesced: no mergeable pair remains.
      noMergeablePair st'.maps ∧
      -- (c) the output is still a well-formed mapping table.
      WellFormed st'.maps ∧
      -- (d) conservativity: coalescing never grows the table.
      st'.maps.length ≤ st.maps.length) ∧
    (∀ s1 s2, coalesceM.run st = some ((), s1) → coalesceM.run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.VSpaceMapCoalesceM
