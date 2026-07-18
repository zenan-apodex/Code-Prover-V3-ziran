/-
  Candidate seL4-style optimization task: IPC waitset batch wake

  Each endpoint owns a FIFO wait queue of blocked threads. The
  `batchWakeM` operation processes a batch of `(endpoint, count)`
  requests: for each request it removes the first `count` threads from
  the endpoint's wait queue and marks each removed thread runnable. The
  endpoint ids in the batch are required to be pairwise distinct so each
  queue is touched at most once.

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over
  per-endpoint wait queues and a per-thread runnable flag.
-/
import Mathlib

namespace seL4Cand.IPCWaitsetBatchWakeM

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

structure KernelState where
  waitq : EpId → List Tid
  runnable : Tid → Bool

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- The endpoints named by a batch of requests. -/
def reqEps (reqs : List (EpId × Nat)) : List EpId := reqs.map Prod.fst

/-- A thread is woken (for endpoint `ep` with count `n`) when it is among the
    first `n` waiters of `ep` in `s`. -/
def wokenBy (s : KernelState) (ep : EpId) (n : Nat) (t : Tid) : Prop :=
  t ∈ (s.waitq ep).take n

/-- A thread is woken by the whole batch when some request wakes it. -/
def wokenByBatch (s : KernelState) (reqs : List (EpId × Nat)) (t : Tid) : Prop :=
  ∃ p, p ∈ reqs ∧ wokenBy s p.1 p.2 t
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def batchWakeM (reqs : List (EpId × Nat)) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem batchWakeM_correct (reqs : List (EpId × Nat)) (st : KernelState)
    (h_nodup : (reqs.map Prod.fst).Nodup) :
    (∃ st', (batchWakeM reqs).run st = some ((), st')) ∧
    (∀ st', (batchWakeM reqs).run st = some ((), st') →
      -- Empty batch is the identity.
      (reqs = [] → st' = st) ∧
      -- FIFO: the first `n` waiters of each requested endpoint leave the queue.
      (∀ ep n, (ep, n) ∈ reqs → st'.waitq ep = (st.waitq ep).drop n) ∧
      -- Every dequeued thread is marked runnable.
      (∀ ep n t, (ep, n) ∈ reqs → wokenBy st ep n t → st'.runnable t = true) ∧
      -- Frame: queues of untouched endpoints are unchanged.
      (∀ ep, ep ∉ reqEps reqs → st'.waitq ep = st.waitq ep) ∧
      -- Frame: the runnable flag of an unwoken thread is unchanged.
      (∀ t, ¬ wokenByBatch st reqs t → st'.runnable t = st.runnable t)) ∧
    (∀ s1 s2, (batchWakeM reqs).run st = some ((), s1) → (batchWakeM reqs).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.IPCWaitsetBatchWakeM
