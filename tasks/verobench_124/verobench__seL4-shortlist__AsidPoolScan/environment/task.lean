/-
  seL4 Optimization Task: ASID Pool Free Slot Scan — Segment Tree variant
  Original: O(1024) linear scan through ASID pool entries
  Optimized: O(log 1024) segment tree query

  The bitmap is replaced by a segment tree. Each internal
  node tracks the count of free slots in its range. The solver must
  implement segment tree query and prove the segment tree invariant
  (count consistency) is maintained. This forces tree-based induction
  with count propagation — fundamentally harder than flat bitmap scans.

  Source: seL4/src/arch/arm/object/objecttype.c
-/
import Mathlib

namespace seL4.AsidPoolScan

-- === BEGIN: DEFINITIONS (provided) ===

abbrev poolSize : Nat := 1024

abbrev PoolSlot := Option Nat

abbrev AsidPool := Fin poolSize → PoolSlot

/-- Segment tree over a range of pool indices.
    - `leaf b` represents a single slot: `b = true` means free.
    - `node l r freeCount rangeSize` represents a range of `rangeSize` slots
      where `freeCount` is the number of free slots. -/
inductive SegTree where
  | leaf : Bool → SegTree
  | node : SegTree → SegTree → Nat → Nat → SegTree
  deriving Repr

/-- Count of free slots in a segment tree. -/
def SegTree.freeCount : SegTree → Nat
  | .leaf b => if b then 1 else 0
  | .node _ _ fc _ => fc

/-- Range size of a segment tree. -/
def SegTree.rangeSize : SegTree → Nat
  | .leaf _ => 1
  | .node _ _ _ rs => rs

/-- Tree height (leaf height = 1). -/
def SegTree.height : SegTree → Nat
  | .leaf _ => 1
  | .node l r _ _ => Nat.succ (Nat.max l.height r.height)

/-- Segment tree is well-formed: counts are consistent, sizes are correct,
    and all internal nodes have positive-size children. -/
def SegTree.WellFormed : SegTree → Prop
  | .leaf _ => True
  | .node l r fc rs =>
    l.WellFormed ∧ r.WellFormed ∧
    fc = l.freeCount + r.freeCount ∧
    rs = l.rangeSize + r.rangeSize ∧
    l.rangeSize > 0 ∧ r.rangeSize > 0

/-- Perfect segment-tree shape: every internal node has equal-sized children. -/
def SegTree.Perfect : SegTree → Prop
  | .leaf _ => True
  | .node l r _ _ =>
    l.Perfect ∧ r.Perfect ∧ l.rangeSize = r.rangeSize

/-- Cost model for the segment-tree scan:
    one step per visited node along the chosen root-to-leaf path. -/
def SegTree.scanCost : SegTree → Nat
  | .leaf _ => 1
  | .node l r _ _ =>
    if l.freeCount = 0 then Nat.succ r.scanCost
    else Nat.succ l.scanCost

/-- Path-cost forced by an explicit index choice. -/
def SegTree.pathCost : SegTree → Nat → Nat
  | .leaf _, _ => 1
  | .node l r _ _, i =>
    if i < l.rangeSize then Nat.succ (l.pathCost i)
    else Nat.succ (r.pathCost (i - l.rangeSize))

/-- Access the i-th bit of the segment tree (0-indexed from left). -/
def SegTree.getBit : SegTree → Nat → Bool
  | .leaf b, _ => b
  | .node l r _ _, i =>
    if i < l.rangeSize then l.getBit i
    else r.getBit (i - l.rangeSize)

/-- Segment tree is consistent with the pool: bit i is true iff slot
    (base + i) is free. -/
def segConsistent (pool : AsidPool) (seg : SegTree) (base : Nat) : Prop :=
  seg.rangeSize + base ≤ poolSize ∧
  ∀ i, i < seg.rangeSize →
    ∀ h : base + i < poolSize,
    seg.getBit i = true ↔ (pool ⟨base + i, h⟩).isNone

/-- First free slot: this slot is free and all earlier slots are occupied. -/
def isFirstFreeSlot (pool : AsidPool) (idx : Fin poolSize) : Prop :=
  (pool idx).isNone ∧ ∀ j : Fin poolSize, j.val < idx.val → (pool j).isSome

/-- All slots are occupied. -/
def allSlotsUsed (pool : AsidPool) : Prop :=
  ∀ j : Fin poolSize, (pool j).isSome

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===
-- No additional predicates.
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

/-- Segment-tree-based scan to find the first free pool slot.
    Must traverse the segment tree to find the leftmost free bit. -/
def segTreeScan (seg : SegTree) : Option Nat :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem segTreeScan_correct (pool : AsidPool) (seg : SegTree)
    (h_wf : seg.WellFormed)
    (h_perfect : seg.Perfect)
    (h_size : seg.rangeSize = poolSize)
    (h_consistent : segConsistent pool seg 0) :
    let out := segTreeScan seg
    -- (1) If scan returns an index, it is the first free slot.
    (∀ idx, out = some idx →
      ∃ h : idx < poolSize, isFirstFreeSlot pool ⟨idx, h⟩) ∧
    -- (2) Scan returns none iff all slots are used.
    (out = none ↔ allSlotsUsed pool) ∧
    -- (3) Scan returns none iff freeCount = 0.
    (out = none ↔ seg.freeCount = 0) ∧
    -- (4) Completeness: if any free slot exists, scan returns some.
    ((∃ idx : Fin poolSize, (pool idx).isNone) → ∃ idx, out = some idx) ∧
    -- (5) Uniqueness: any index satisfying isFirstFreeSlot equals the result.
    (∀ idx : Fin poolSize, isFirstFreeSlot pool idx → out = some idx.val) ∧
    -- (6) Segment tree structure: the result index corresponds to the
    --     leftmost true-bit in the tree.
    (∀ idx, out = some idx →
      seg.getBit idx = true ∧
      ∀ j, j < idx → seg.getBit j = false) ∧
    -- (7) Returned index is always in range.
    (∀ idx, out = some idx → idx < seg.rangeSize) ∧
    -- (8) Monotonicity: freeing a slot cannot cause scan to return none.
    (∀ seg' : SegTree, seg'.WellFormed → seg'.rangeSize = poolSize →
      (∀ i, i < poolSize → seg.getBit i = true → seg'.getBit i = true) →
      out ≠ none → segTreeScan seg' ≠ none) ∧
    -- (9) Determinism.
    (∀ idx₁ idx₂, out = some idx₁ → segTreeScan seg = some idx₂ →
      idx₁ = idx₂) ∧
    -- (10) Path-cost bound: traversal visits at most one node per level.
    (seg.scanCost ≤ seg.height) ∧
    -- (11) Under perfect shape, height is logarithmic in range size.
    (seg.height ≤ Nat.log2 seg.rangeSize + 1) ∧
    -- (12) Exact path accounting on successful lookup.
    (∀ idx, out = some idx → seg.scanCost = seg.pathCost idx) ∧
    -- (13) Returned index is itself the leftmost free bit (minimal witness).
    (∀ idx, out = some idx →
      seg.getBit idx = true ∧
      ∀ j, j < seg.rangeSize → seg.getBit j = true → idx ≤ j) ∧
    -- (14) Option exclusivity.
    (out = none → ¬ ∃ idx, out = some idx) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- === END: AUX ===

end seL4.AsidPoolScan
