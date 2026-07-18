/-
  Candidate seL4-style optimization task: IRQ route-table compression (dedup)

  This benchmark models compaction of per-IRQ routing tables. Each IRQ in the
  range `[0, irqBound)` carries a list of target cores (`routes : Irq → List Core`)
  that may contain duplicate entries accumulated over time. Compression rewrites
  every in-range routing list to its first-occurrence dedup (each core kept at the
  position of its earliest appearance, later repeats dropped) and accumulates the
  total number of removed duplicate slots into the `saved` counter. Routing lists
  for IRQs at or above the bound are left untouched, as is the bound itself.

  Expected solution style: map `dedupFirst` over `List.range irqBound`, rewriting
  the routing function, and fold the per-IRQ length differences into `saved`.
-/
import Mathlib

namespace seL4Cand.IRQRouteCompressM

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

abbrev Irq := Nat
abbrev Core := Nat

structure KernelState where
  routes : Irq → List Core
  saved : Nat
  irqBound : Nat
-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- First-occurrence dedup: keep the earliest copy of each element, drop later
    repeats. Quadratic recursion via `filter`. -/
def dedupFirst : List Nat → List Nat
  | [] => []
  | x :: xs => x :: dedupFirst (xs.filter (· ≠ x))
  termination_by l => l.length
  decreasing_by
    simp_wf
    exact Nat.le_trans (List.length_filter_le _ _) (Nat.le_of_eq List.length_attach)

/-- Total number of duplicate slots removed across all in-range routing lists. -/
def savings (st : KernelState) : Nat :=
  (List.range st.irqBound).foldl
    (fun acc i => acc + ((st.routes i).length - (dedupFirst (st.routes i)).length)) 0
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def compressRoutesM : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem compressRoutesM_correct (st : KernelState) :
    (∃ st', compressRoutesM.run st = some ((), st')) ∧
    (∀ st', compressRoutesM.run st = some ((), st') →
      -- (a) In-range routing lists are deduplicated (first occurrence kept).
      (∀ i, i < st.irqBound → st'.routes i = dedupFirst (st.routes i)) ∧
      -- (b) Frame: routing lists at or above the bound are unchanged.
      (∀ i, st.irqBound ≤ i → st'.routes i = st.routes i) ∧
      -- (c) The IRQ bound is unchanged.
      st'.irqBound = st.irqBound ∧
      -- (d) Count witness: saved grows by the total removed duplicate slots.
      st'.saved = st.saved + savings st) ∧
    (∀ s1 s2, compressRoutesM.run st = some ((), s1) → compressRoutesM.run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.IRQRouteCompressM
