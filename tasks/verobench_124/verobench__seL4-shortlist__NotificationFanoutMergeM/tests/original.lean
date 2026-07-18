/-
  Candidate seL4-style optimization task: notification fanout merge

  Each notification object holds a badge word (a bitset packed into a
  `Nat`) and a list of waiting threads. The `fanoutM` operation merges a
  batch of signals: for each `(ntfn, badge)` it ORs the badge into the
  notification's word, and, if any threads were waiting on that
  notification, it wakes them all (appending them to a global woken log
  and clearing the waiter list). The signalled notification ids are
  required to be pairwise distinct.

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over
  per-notification badge words, waiter lists, and a shared woken log.
-/
import Mathlib

namespace seL4Cand.NotificationFanoutMergeM

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

abbrev NtfnId := Nat
abbrev Tid := Nat

structure KernelState where
  word : NtfnId → Nat
  waiters : NtfnId → List Tid
  woken : List Tid

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- The notifications named by a batch of signals. -/
def sigNtfns (sigs : List (NtfnId × Nat)) : List NtfnId := sigs.map Prod.fst

/-- A notification is signalled when it appears in the batch. -/
def signalled (sigs : List (NtfnId × Nat)) (ntfn : NtfnId) : Prop := ntfn ∈ sigNtfns sigs
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def fanoutM (sigs : List (NtfnId × Nat)) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem fanoutM_correct (sigs : List (NtfnId × Nat)) (st : KernelState)
    (h_nodup : (sigs.map Prod.fst).Nodup) :
    (∃ st', (fanoutM sigs).run st = some ((), st')) ∧
    (∀ st', (fanoutM sigs).run st = some ((), st') →
      -- Empty batch is the identity.
      (sigs = [] → st' = st) ∧
      -- Each signalled badge is merged into the notification word by bitwise OR.
      (∀ ntfn badge, (ntfn, badge) ∈ sigs → st'.word ntfn = Nat.lor (st.word ntfn) badge) ∧
      -- Signalled notifications have their waiter list emptied.
      (∀ ntfn, signalled sigs ntfn → st'.waiters ntfn = []) ∧
      -- Frame: unsignalled notifications keep their word.
      (∀ ntfn, ¬ signalled sigs ntfn → st'.word ntfn = st.word ntfn) ∧
      -- Frame: unsignalled notifications keep their waiters.
      (∀ ntfn, ¬ signalled sigs ntfn → st'.waiters ntfn = st.waiters ntfn) ∧
      -- Every waiter of a signalled notification is woken.
      (∀ ntfn t, signalled sigs ntfn → t ∈ st.waiters ntfn → t ∈ st'.woken) ∧
      -- Conservativity: every woken thread is old or was a waiter of a signalled notification.
      (∀ t, t ∈ st'.woken → t ∈ st.woken ∨ ∃ ntfn, signalled sigs ntfn ∧ t ∈ st.waiters ntfn) ∧
      -- Old woken threads are preserved.
      (∀ t, t ∈ st.woken → t ∈ st'.woken)) ∧
    (∀ s1 s2, (fanoutM sigs).run st = some ((), s1) → (fanoutM sigs).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.NotificationFanoutMergeM
