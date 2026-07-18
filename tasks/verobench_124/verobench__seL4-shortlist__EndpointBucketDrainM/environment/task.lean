/-
  Candidate seL4-style optimization task: endpoint bucket draining

  Each endpoint owns a FIFO bucket of pending messages. The `drainM`
  operation walks a list of endpoint ids, empties each named bucket, and
  appends the drained messages (in endpoint order) to a global delivery
  log. The endpoint id list is required to be duplicate-free so that no
  bucket is drained twice.

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over
  per-endpoint buckets and a shared delivery log.
-/
import Mathlib

namespace seL4Cand.EndpointBucketDrainM

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
@[simp] theorem KM.set_run {σ : Type} (s s' : σ) : (KM.set s').run s = some ((), s') := rfl
@[simp] theorem KM.modify_run {σ : Type} (f : σ → σ) (s : σ) :
    (KM.modify f).run s = some ((), f s) := rfl

abbrev EpId := Nat
abbrev Tid := Nat

structure Msg where
  sender : Nat
  payload : Nat
  deriving DecidableEq, Repr

structure KernelState where
  buckets : EpId → List Msg
  delivered : List Msg

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- Messages drained by `eps`, in endpoint order, read from state `s`. -/
def drainedMsgs (s : KernelState) (eps : List EpId) : List Msg :=
  eps.foldl (fun acc ep => acc ++ s.buckets ep) []

/-- An endpoint is touched when it appears in the drain list. -/
def touched (eps : List EpId) (ep : EpId) : Prop := ep ∈ eps
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def drainM (eps : List EpId) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem drainM_correct (eps : List EpId) (st : KernelState)
    (h_nodup : eps.Nodup) :
    (∃ st', (drainM eps).run st = some ((), st')) ∧
    (∀ st', (drainM eps).run st = some ((), st') →
      -- Empty drain list is the identity.
      (eps = [] → st' = st) ∧
      -- Every drained endpoint's bucket is empty afterwards.
      (∀ ep, touched eps ep → st'.buckets ep = []) ∧
      -- Frame: untouched endpoints keep their buckets.
      (∀ ep, ¬ touched eps ep → st'.buckets ep = st.buckets ep) ∧
      -- Delivery log grows by exactly the drained messages, in endpoint order.
      (st'.delivered = drainedMsgs st eps ++ st.delivered) ∧
      -- Conservativity: every delivered message is old or came from a drained bucket.
      (∀ m, m ∈ st'.delivered → m ∈ st.delivered ∨ ∃ ep, touched eps ep ∧ m ∈ st.buckets ep) ∧
      -- Conservativity: buckets never gain fabricated messages.
      (∀ ep m, m ∈ st'.buckets ep → m ∈ st.buckets ep)) ∧
    (∀ s1 s2, (drainM eps).run st = some ((), s1) → (drainM eps).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.EndpointBucketDrainM
