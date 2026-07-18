/-
  Candidate seL4-style optimization task: reply tree cutover

  This benchmark models a reply/endpoint tree as a parent pointer function
  together with a liveness bitmap, over an address space bounded by `bound`.
  A "cutover" removes a set of internal nodes from the tree: each cut node is
  marked dead, and every node that pointed at a cut node is re-parented onto
  the cut node's own parent (its grandparent), so that the remaining tree stays
  connected without the spliced-out nodes.

  To keep re-parenting a single-step operation we require that the cut set is
  an antichain of edges: no cut node is the parent of another cut node, so a
  re-parent never needs to chase through a second cut. Without this assumption
  a node pointing at cut node `c` whose parent is itself a cut node `d` would
  need a multi-step splice; the antichain hypothesis rules this out and makes
  the grandparent the final destination.

  Correctness pins down four things. Cut nodes become dead. A surviving node
  that pointed at a cut node now points at that cut node's parent. A node whose
  parent was never cut keeps its parent (frame). A node that was not itself cut
  keeps its liveness (frame). The address-space bound is invariant, and an empty
  cut set leaves the whole state untouched.

  Expected solution style: pointwise redefinition of the parent and liveness
  functions, leaving the bound untouched.
-/
import Mathlib

namespace seL4Cand.ReplyTreeCutoverM

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

structure KernelState where
  parent : Nat → Option Nat
  live : Nat → Bool
  bound : Nat

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- The cut set is an edge antichain: no cut node is the parent of another
    cut node. This makes re-parenting a single-step grandparent splice. -/
def cutsAntichain (parent : Nat → Option Nat) (cuts : List Nat) : Prop :=
  ∀ c ∈ cuts, ∀ d ∈ cuts, parent c ≠ some d

/-- A node `n` points (directly) at some node in the cut set. -/
def pointsAtCut (parent : Nat → Option Nat) (cuts : List Nat) (n : Nat) : Prop :=
  ∃ c ∈ cuts, parent n = some c

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

def cutoverM (cuts : List Nat) : KM KernelState Unit :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem cutoverM_correct (cuts : List Nat) (st : KernelState)
    (h_nodup : cuts.Nodup)
    (h_antichain : cutsAntichain st.parent cuts) :
    (∃ st', (cutoverM cuts).run st = some ((), st')) ∧
    (∀ st', (cutoverM cuts).run st = some ((), st') →
      -- (a) every cut node is marked dead.
      (∀ c ∈ cuts, c < st.bound → st'.live c = false) ∧
      -- (b) re-parenting: a node pointing at a cut node is spliced onto the
      --     cut node's parent (its grandparent).
      (∀ n c, n < st.bound → st'.live n = true → c ∈ cuts → st.parent n = some c →
        st'.parent n = st.parent c) ∧
      -- (c) frame: a node whose parent is not cut keeps its parent.
      (∀ n, ¬ pointsAtCut st.parent cuts n → st'.parent n = st.parent n) ∧
      -- (d) frame: a non-cut node keeps its liveness bit.
      (∀ n, n ∉ cuts → st'.live n = st.live n) ∧
      -- (e) the bound is never modified.
      st'.bound = st.bound ∧
      -- (f) an empty cut set is the identity.
      (cuts = [] → st' = st)) ∧
    (∀ s1 s2, (cutoverM cuts).run st = some ((), s1) → (cutoverM cuts).run st = some ((), s2) → s1 = s2) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- (add helper lemmas here)
-- === END: AUX ===

end seL4Cand.ReplyTreeCutoverM
