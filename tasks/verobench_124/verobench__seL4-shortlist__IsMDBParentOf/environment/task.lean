/-
  seL4 Optimization Task: isMDBParentOf — badge hierarchy decision tree
  Source: src/object/cnode.c:775-819

  Expanded to 8 cap types with badge masking and guard
  comparison. The solver must implement a decision function covering
  all type×type combinations (64 cases) with badge mask/guard logic.
  A decision tree witness must be produced alongside the function.
-/
import Mathlib

namespace seL4.IsMDBParentOf

-- === BEGIN: DEFINITIONS (provided) ===

inductive CapType where
  | endpoint
  | notification
  | cnode
  | untyped
  | reply
  | frame
  | irqHandler
  | other
  deriving DecidableEq, Repr

structure CapInfo where
  ctype       : CapType
  badge       : Nat         -- 0 = "no badge" (master cap)
  badgeMask   : Nat         -- mask applied before badge comparison
  guardBits   : Nat         -- guard size (cnode only)
  firstBadged : Bool
  deriving DecidableEq, Repr

/-- Badge match under masking: a's badge (masked) contains b's badge (masked). -/
def badgeMatch (a b : CapInfo) : Bool :=
  (a.badge &&& a.badgeMask) == (b.badge &&& a.badgeMask)

/-- Cap types that support badge-based parent relationship. -/
def isBadgeable : CapType → Bool
  | .endpoint => true
  | .notification => true
  | _ => false

/-- Cap types that support guard-based parent relationship. -/
def isGuardable : CapType → Bool
  | .cnode => true
  | _ => false

/-- Decision tree for the parent check. The solver must produce a
    `DecTree` value AND prove it implements `isParentTable`. -/
inductive DecTree where
  | result : Bool → DecTree
  | branchTypeEq : DecTree → DecTree → DecTree      -- same type? → yes / no
  | branchBadgeable : DecTree → DecTree → DecTree    -- isBadgeable? → yes / no
  | branchGuardable : DecTree → DecTree → DecTree    -- isGuardable? → yes / no
  | branchMasterA : DecTree → DecTree → DecTree      -- a.badge = 0? → yes / no
  | branchBadgeMatch : DecTree → DecTree → DecTree   -- badgeMatch? → yes / no
  | branchFirstBadged : DecTree → DecTree → DecTree  -- b.firstBadged? → yes / no
  | branchGuardLeq : DecTree → DecTree → DecTree     -- a.guardBits ≤ b.guardBits? → yes / no
  deriving Repr

/-- Evaluate a decision tree on a pair of CapInfos. -/
def DecTree.eval (a b : CapInfo) : DecTree → Bool
  | .result v => v
  | .branchTypeEq yes no =>
    if a.ctype = b.ctype then yes.eval a b else no.eval a b
  | .branchBadgeable yes no =>
    if isBadgeable a.ctype then yes.eval a b else no.eval a b
  | .branchGuardable yes no =>
    if isGuardable a.ctype then yes.eval a b else no.eval a b
  | .branchMasterA yes no =>
    if a.badge = 0 then yes.eval a b else no.eval a b
  | .branchBadgeMatch yes no =>
    if badgeMatch a b then yes.eval a b else no.eval a b
  | .branchFirstBadged yes no =>
    if b.firstBadged then yes.eval a b else no.eval a b
  | .branchGuardLeq yes no =>
    if a.guardBits ≤ b.guardBits then yes.eval a b else no.eval a b

/-- Depth of a decision tree. -/
def DecTree.depth : DecTree → Nat
  | .result _ => 0
  | .branchTypeEq l r => max l.depth r.depth + 1
  | .branchBadgeable l r => max l.depth r.depth + 1
  | .branchGuardable l r => max l.depth r.depth + 1
  | .branchMasterA l r => max l.depth r.depth + 1
  | .branchBadgeMatch l r => max l.depth r.depth + 1
  | .branchFirstBadged l r => max l.depth r.depth + 1
  | .branchGuardLeq l r => max l.depth r.depth + 1

/-- Number of nodes in the decision tree (internal + leaves). -/
def DecTree.nodeCount : DecTree → Nat
  | .result _ => 1
  | .branchTypeEq l r => 1 + l.nodeCount + r.nodeCount
  | .branchBadgeable l r => 1 + l.nodeCount + r.nodeCount
  | .branchGuardable l r => 1 + l.nodeCount + r.nodeCount
  | .branchMasterA l r => 1 + l.nodeCount + r.nodeCount
  | .branchBadgeMatch l r => 1 + l.nodeCount + r.nodeCount
  | .branchFirstBadged l r => 1 + l.nodeCount + r.nodeCount
  | .branchGuardLeq l r => 1 + l.nodeCount + r.nodeCount

/-- Number of result leaves in the decision tree. -/
def DecTree.leafCount : DecTree → Nat
  | .result _ => 1
  | .branchTypeEq l r => l.leafCount + r.leafCount
  | .branchBadgeable l r => l.leafCount + r.leafCount
  | .branchGuardable l r => l.leafCount + r.leafCount
  | .branchMasterA l r => l.leafCount + r.leafCount
  | .branchBadgeMatch l r => l.leafCount + r.leafCount
  | .branchFirstBadged l r => l.leafCount + r.leafCount
  | .branchGuardLeq l r => l.leafCount + r.leafCount

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- Reference parent-spec formula (independent of implementation). -/
def parentSpec (a b : CapInfo) : Bool :=
  match a.ctype, b.ctype with
  | .endpoint, .endpoint =>
      if a.badge = 0 then true
      else if badgeMatch a b then !b.firstBadged else false
  | .notification, .notification =>
      if a.badge = 0 then true
      else if badgeMatch a b then !b.firstBadged else false
  | .cnode, .cnode =>
      decide (a.guardBits ≤ b.guardBits)
  | .untyped, .untyped => false
  | .reply, .reply => false
  | .frame, .frame => false
  | .irqHandler, .irqHandler => false
  | .other, .other => false
  | _, _ => false
-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

/-- The parent-check function. -/
def isParentTable (a b : CapInfo) : Bool :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable, isParentTable) ===
  sorry
-- === END: IMPLEMENTATION (isParentTable) ===

/-- A decision tree that computes the same function as isParentTable. -/
def parentDecTree : DecTree :=
-- === BEGIN: IMPLEMENTATION (editable, parentDecTree) ===
  sorry
-- === END: IMPLEMENTATION (parentDecTree) ===

-- === BEGIN: THEOREM (provided) ===

theorem isParent_correct :
    -- (1) Cross-type caps never relate.
    (∀ a b : CapInfo, a.ctype ≠ b.ctype → isParentTable a b = false) ∧
    -- (2) Non-badgeable, non-guardable types never participate.
    (∀ a b : CapInfo, ¬ isBadgeable a.ctype ∧ ¬ isGuardable a.ctype →
      isParentTable a b = false) ∧
    -- (3) Master badge (0) on badgeable same-type → parent.
    (∀ a b : CapInfo,
      a.ctype = b.ctype → isBadgeable a.ctype → a.badge = 0 →
      isParentTable a b = true) ∧
    -- (4) Same-badge-under-mask rule.
    (∀ a b : CapInfo,
      a.ctype = b.ctype → isBadgeable a.ctype →
      a.badge ≠ 0 → badgeMatch a b → b.firstBadged = false →
      isParentTable a b = true) ∧
    -- (5) firstBadged boundary: same badge but firstBadged → not parent.
    (∀ a b : CapInfo,
      isBadgeable a.ctype → a.badge ≠ 0 →
      badgeMatch a b → b.firstBadged = true →
      isParentTable a b = false) ∧
    -- (6) Badge mismatch on badgeable → not parent.
    (∀ a b : CapInfo,
      a.ctype = b.ctype → isBadgeable a.ctype →
      a.badge ≠ 0 → ¬ badgeMatch a b →
      isParentTable a b = false) ∧
    -- (7) CNode guard rule: same cnode type, guard fits → parent.
    (∀ a b : CapInfo,
      a.ctype = .cnode → b.ctype = .cnode →
      a.guardBits ≤ b.guardBits →
      isParentTable a b = true) ∧
    -- (8) CNode guard too large → not parent.
    (∀ a b : CapInfo,
      a.ctype = .cnode → b.ctype = .cnode →
      a.guardBits > b.guardBits →
      isParentTable a b = false) ∧
    -- (9) Decision tree equivalence: parentDecTree computes isParentTable.
    (∀ a b : CapInfo, parentDecTree.eval a b = isParentTable a b) ∧
    -- (10) 64-case coverage against explicit type-pair enumeration
    --      with an independent spec function.
    (∀ ta tb : CapType, ∀ a b : CapInfo,
      a.ctype = ta → b.ctype = tb → isParentTable a b = parentSpec a b) ∧
    -- (11) Decision tree must also directly implement the independent spec.
    (∀ a b : CapInfo, parentDecTree.eval a b = parentSpec a b) ∧
    -- (12) Decision tree depth is exact.
    (parentDecTree.depth ≤ 5 ∧ 5 ≤ parentDecTree.depth) ∧
    -- (13) Decision tree structural complexity is exact.
    (parentDecTree.nodeCount = 15 ∧ parentDecTree.leafCount = 8) ∧
    -- (14) Determinism: any function satisfying (1)-(8) agrees with isParentTable.
    (∀ f : CapInfo → CapInfo → Bool,
      (∀ a b, a.ctype ≠ b.ctype → f a b = false) →
      (∀ a b, ¬ isBadgeable a.ctype ∧ ¬ isGuardable a.ctype → f a b = false) →
      (∀ a b, a.ctype = b.ctype → isBadgeable a.ctype → a.badge = 0 → f a b = true) →
      (∀ a b, a.ctype = b.ctype → isBadgeable a.ctype →
        a.badge ≠ 0 → badgeMatch a b → b.firstBadged = false → f a b = true) →
      (∀ a b, isBadgeable a.ctype → a.badge ≠ 0 →
        badgeMatch a b → b.firstBadged = true → f a b = false) →
      (∀ a b, a.ctype = b.ctype → isBadgeable a.ctype →
        a.badge ≠ 0 → ¬ badgeMatch a b → f a b = false) →
      (∀ a b, a.ctype = .cnode → b.ctype = .cnode →
        a.guardBits ≤ b.guardBits → f a b = true) →
      (∀ a b, a.ctype = .cnode → b.ctype = .cnode →
        a.guardBits > b.guardBits → f a b = false) →
      ∀ a b, f a b = isParentTable a b) ∧
    -- (15) Totality of boolean decision output.
    (∀ a b : CapInfo, isParentTable a b = true ∨ isParentTable a b = false) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- === END: AUX ===

end seL4.IsMDBParentOf
