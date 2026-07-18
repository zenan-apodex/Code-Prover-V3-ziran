/-
  Candidate seL4-style optimization task: SMP queue steal-balance with weighted redistribution

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over
  per-CPU ready queues, readiness bitmaps, and affinity/budget state.
-/
import Mathlib

namespace seL4Cand.SMPQueueStealBalanceM

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

abbrev CpuId := Nat
abbrev ThreadId := Nat
abbrev Priority := Nat

structure WaitQ where
  head : List ThreadId
  tail : List ThreadId
  deriving Repr

abbrev ReadyQueues := CpuId → Priority → WaitQ
abbrev ReadyBitmap := CpuId → Priority → Bool
abbrev Affinity := ThreadId → CpuId
abbrev Budget := ThreadId → Nat

structure KernelState where
  queues : ReadyQueues
  bitmap : ReadyBitmap
  affinity : Affinity
  budget : Budget
  current : CpuId → Option ThreadId

inductive Op where
  | enqueue (cpu prio tid : Nat)
  | migrate (tid dst : Nat)
  | boost (tid prioDelta : Nat)
  | consume (cpu tid ticks : Nat)
  | flush (cpu prio : Nat)
  deriving DecidableEq, Repr
-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

def queueLen (q : WaitQ) : Nat := q.head.length + q.tail.length

def queueElems (q : WaitQ) : List ThreadId := q.head ++ q.tail.reverse

def bitmapConsistent (s : KernelState) : Prop :=
  ∀ cpu prio, s.bitmap cpu prio = true ↔ queueLen (s.queues cpu prio) > 0

def opCost : Op → Nat
  | .enqueue _ prio _ => prio + 1
  | .migrate _ _ => 2
  | .boost _ d => d + 1
  | .consume _ _ t => t + 1
  | .flush _ p => p + 1

def batchCost : List Op → Nat := List.foldl (fun acc op => acc + opCost op) 0

def mentionsTid : Op → ThreadId → Prop
  | .enqueue _ _ tid, t => tid = t
  | .migrate tid _, t => tid = t
  | .boost tid _, t => tid = t
  | .consume _ tid _, t => tid = t
  | .flush _ _, _ => False

def touchedTid (ops : List Op) (tid : ThreadId) : Prop := ∃ op, op ∈ ops ∧ mentionsTid op tid

def enqueuedAt (ops : List Op) (cpu prio tid : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .enqueue cpu prio tid

def flushedCell (ops : List Op) (cpu prio : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .flush cpu prio

def migratedTo (ops : List Op) (tid dst : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .migrate tid dst

def consumedTicks (ops : List Op) (tid : Nat) : Nat :=
  match ops with
  | [] => 0
  | .consume _ t k :: tl => (if t = tid then k else 0) + consumedTicks tl tid
  | _ :: tl => consumedTicks tl tid

def boostedBy (ops : List Op) (tid : Nat) : Nat :=
  match ops with
  | [] => 0
  | .boost t d :: tl => (if t = tid then d else 0) + boostedBy tl tid
  | _ :: tl => boostedBy tl tid

/-- Conflict-free `ops`: required to make the post-conditions of
    `balanceStealM_correct` simultaneously satisfiable. -/
def noConflictingOps (ops : List Op) : Prop :=
  (∀ cpu prio tid, enqueuedAt ops cpu prio tid → ¬flushedCell ops cpu prio) ∧
  (∀ tid d1 d2, migratedTo ops tid d1 → migratedTo ops tid d2 → d1 = d2) ∧
  (batchCost ops > 0 → ∃ cpu prio tid, enqueuedAt ops cpu prio tid)
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- no axioms
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def balanceStealM (ops : List Op) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem balanceStealM_correct (ops : List Op) (st : KernelState)
    (h_bitmap : bitmapConsistent st)
    (h_noconfl : noConflictingOps ops) :
    (∃ st', (balanceStealM ops).run st = some ((), st')) ∧
    (∀ st', (balanceStealM ops).run st = some ((), st') →
      bitmapConsistent st' ∧
      (ops = [] → st' = st) ∧
      (∀ tid, ¬touchedTid ops tid → st'.affinity tid = st.affinity tid ∧ st'.budget tid = st.budget tid) ∧
      (∀ cpu prio tid, enqueuedAt ops cpu prio tid → tid ∈ queueElems (st'.queues cpu prio)) ∧
      (∀ cpu prio, flushedCell ops cpu prio → queueElems (st'.queues cpu prio) = [] ∧ st'.bitmap cpu prio = false) ∧
      (∀ tid dst, migratedTo ops tid dst → st'.affinity tid = dst) ∧
      (∀ tid, boostedBy ops tid > 0 → st'.budget tid ≥ st.budget tid + boostedBy ops tid) ∧
      (∀ tid, consumedTicks ops tid > 0 → st'.budget tid + consumedTicks ops tid ≤ st.budget tid + batchCost ops) ∧
      (batchCost ops > 0 → ∃ cpu prio, st'.bitmap cpu prio = true)) ∧
    (∀ s1 s2, (balanceStealM ops).run st = some ((), s1) → (balanceStealM ops).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- helper lemmas
-- === END: AUX ===

end seL4Cand.SMPQueueStealBalanceM
