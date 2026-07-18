/-
  Candidate seL4-style optimization task: fault-log compaction with interval-preserving splice

  This benchmark is intentionally monadic and data-structure heavy.
  Expected solution style: recursive stateful transformation over
  event logs, route tables, pending sets, and credit counters.
-/
import Mathlib

namespace seL4Cand.FaultLogCompactionM

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

abbrev SourceId := Nat
abbrev EventId := Nat
abbrev ShardId := Nat

structure Event where
  src : SourceId
  tag : Nat
  payload : Nat
  deriving DecidableEq, Repr

abbrev LogBuf := List Event
abbrev Routes := SourceId → List ShardId
abbrev Pending := ShardId → List EventId
abbrev Credits := ShardId → Nat

structure KernelState where
  log : LogBuf
  routes : Routes
  pending : Pending
  credits : Credits
  owner : EventId → ShardId

inductive Op where
  | append (src tag payload : Nat)
  | route (src shard : Nat)
  | dispatch (shard eid : Nat)
  | compact (src : Nat)
  | refill (shard credit : Nat)
  deriving DecidableEq, Repr
-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

def logSize (s : KernelState) : Nat := s.log.length

def opCost : Op → Nat
  | .append _ t p => t + p + 1
  | .route _ _ => 2
  | .dispatch _ _ => 2
  | .compact _ => 1
  | .refill _ c => c + 1

def batchCost : List Op → Nat := List.foldl (fun acc op => acc + opCost op) 0

def appendsEvent (ops : List Op) (src tag payload : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .append src tag payload

def routesTo (ops : List Op) (src shard : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .route src shard

def dispatches (ops : List Op) (shard eid : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .dispatch shard eid

def compactsSrc (ops : List Op) (src : Nat) : Prop := ∃ op, op ∈ ops ∧ op = .compact src

def refillsBy (ops : List Op) (shard : Nat) : Nat :=
  match ops with
  | [] => 0
  | .refill s c :: tl => (if s = shard then c else 0) + refillsBy tl shard
  | _ :: tl => refillsBy tl shard
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- no axioms
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def compactFaultLogM (ops : List Op) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem compactFaultLogM_correct (ops : List Op) (st : KernelState) :
    (∃ st', (compactFaultLogM ops).run st = some ((), st')) ∧
    (∀ st', (compactFaultLogM ops).run st = some ((), st') →
      (ops = [] → st' = st) ∧
      (∀ src tag payload, appendsEvent ops src tag payload → ∃ e, e ∈ st'.log ∧ e = ⟨src, tag, payload⟩) ∧
      (∀ src shard, routesTo ops src shard → shard ∈ st'.routes src) ∧
      (∀ shard eid, dispatches ops shard eid → eid ∉ st'.pending shard) ∧
      (∀ src, compactsSrc ops src → st'.log.length ≤ st.log.length + batchCost ops) ∧
      (∀ shard, refillsBy ops shard > 0 → st'.credits shard ≥ st.credits shard + refillsBy ops shard) ∧
      (batchCost ops > 0 → logSize st' ≥ logSize st) ∧
      -- Frame: sources never routed keep their route list.
      (∀ src, (∀ shard, ¬ routesTo ops src shard) → st'.routes src = st.routes src) ∧
      -- Frame: shards never dispatched keep their pending list.
      (∀ shard, (∀ eid, ¬ dispatches ops shard eid) → st'.pending shard = st.pending shard) ∧
      -- Frame: shards never refilled keep their credits.
      (∀ shard, refillsBy ops shard = 0 → st'.credits shard = st.credits shard) ∧
      -- Frame: the owner map is never modified.
      st'.owner = st.owner ∧
      -- Dispatch precision: only dispatched event ids may leave a pending set.
      (∀ shard e, e ∈ st.pending shard → ¬ dispatches ops shard e → e ∈ st'.pending shard) ∧
      -- Conservativity: no fabricated pending entries.
      (∀ shard e, e ∈ st'.pending shard → e ∈ st.pending shard) ∧
      -- Conservativity: every output route is an old route or explicitly added.
      (∀ src shard, shard ∈ st'.routes src → shard ∈ st.routes src ∨ routesTo ops src shard) ∧
      -- Conservativity: every output log event is an old event or explicitly appended.
      (∀ e, e ∈ st'.log → e ∈ st.log ∨ appendsEvent ops e.src e.tag e.payload) ∧
      -- Log preservation: absent compaction, old events survive.
      ((∀ src, ¬ compactsSrc ops src) → ∀ e, e ∈ st.log → e ∈ st'.log)) ∧
    (∀ s1 s2, (compactFaultLogM ops).run st = some ((), s1) → (compactFaultLogM ops).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- helper lemmas
-- === END: AUX ===

end seL4Cand.FaultLogCompactionM
