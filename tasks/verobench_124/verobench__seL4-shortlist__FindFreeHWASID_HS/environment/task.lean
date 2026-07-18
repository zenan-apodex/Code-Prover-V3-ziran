/-
  seL4 Haskell Spec Optimization: findFreeHWASID
  Source: SEL4/Kernel/VSpace/ARM.lhs:1053-1061

  Modified via inductive `CircularSearch` relation + functional
  extensionality clause. The spec is no longer "find the result"
  but "satisfy a custom inductive search predicate, AND any function
  satisfying that predicate is extensionally equal to yours". This
  defeats `Fin.find` / `Finset.min'` / `Multiset` shortcuts because
  Mathlib has no lemmas about this custom relation.
-/
import Mathlib

namespace seL4.FindFreeHWASID_HS

-- === BEGIN: DEFINITIONS (provided) ===

abbrev hwAsidCount : Nat := 256

abbrev HwAsid := Fin hwAsidCount
abbrev HwAsidTable := HwAsid → Option Nat

/-- Circular distance from `nextAsid` to `a`, in `[0, hwAsidCount)`. -/
def circDist (nextAsid a : HwAsid) : Nat :=
  (a.val + hwAsidCount - nextAsid.val) % hwAsidCount

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- Inductive characterization of "the result of a circular search
    starting from `nextAsid`". The relation is parameterized by the
    table and the starting point.

    `CircularSearch table nextAsid d r` says: `r` is the first free
    ASID encountered when scanning circularly from `nextAsid`, and the
    minimal distance is `d`. Both `d` and `r` are uniquely determined
    by the relation. -/
inductive CircularSearch :
    HwAsidTable → HwAsid → (d : Fin hwAsidCount) → HwAsid → Prop where
  | found_zero
      (table : HwAsidTable) (nextAsid : HwAsid)
      (h_free : (table nextAsid).isNone) :
      CircularSearch table nextAsid ⟨0, by decide⟩ nextAsid
  | step
      (table : HwAsidTable) (nextAsid : HwAsid)
      (d : Fin hwAsidCount) (r : HwAsid)
      (hd : 0 < d.val)
      (h_busy_at_pred :
        ∀ d' : Fin hwAsidCount, d'.val < d.val →
          (table ⟨(nextAsid.val + d'.val) % hwAsidCount,
                  Nat.mod_lt _ (by decide : 0 < hwAsidCount)⟩).isSome)
      (h_free_at :
        (table ⟨(nextAsid.val + d.val) % hwAsidCount,
                  Nat.mod_lt _ (by decide : 0 < hwAsidCount)⟩).isNone)
      (h_r : r = ⟨(nextAsid.val + d.val) % hwAsidCount,
                  Nat.mod_lt _ (by decide : 0 < hwAsidCount)⟩) :
      CircularSearch table nextAsid d r

/-- The "no free ASID exists" predicate for the table. -/
def allBusy (table : HwAsidTable) : Prop :=
  ∀ a : HwAsid, (table a).isSome

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No additional axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

/-- Find a free HW ASID, returning both the result and the circular
    distance from `nextAsid` at which it was found. The dual return
    type is anchored to `CircularSearch`. -/
def findOptimized (table : HwAsidTable) (nextAsid : HwAsid) :
    Option (HwAsid × Fin hwAsidCount) :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem findFreeHWASID_correct (table : HwAsidTable) (nextAsid : HwAsid) :
    let out := findOptimized table nextAsid
    -- (1) When `out = some (r, d)`, the inductive search relation holds.
    (∀ r d, out = some (r, d) → CircularSearch table nextAsid d r) ∧
    -- (2) When `out = none`, every ASID is busy.
    (out = none ↔ allBusy table) ∧
    -- (3) `CircularSearch` is *functional* in `(d, r)`: any two witnesses
    --     for the same `(table, nextAsid)` agree on both `d` and `r`.
    (∀ d₁ d₂ r₁ r₂,
      CircularSearch table nextAsid d₁ r₁ →
      CircularSearch table nextAsid d₂ r₂ →
      d₁ = d₂ ∧ r₁ = r₂) ∧
    -- (4) Extensionality: any other function `f` returning the same
    --     "search semantics" extensionally equals `findOptimized`.
    (∀ f : HwAsidTable → HwAsid → Option (HwAsid × Fin hwAsidCount),
      (∀ t n,
        (f t n = none ↔ allBusy t) ∧
        (∀ r d, f t n = some (r, d) → CircularSearch t n d r)) →
      f table nextAsid = findOptimized table nextAsid) ∧
    -- (5) Pivot independence: starting the scan from the result yields
    --     the result with distance 0.
    (∀ r d, out = some (r, d) →
      findOptimized table r = some (r, ⟨0, by decide⟩)) ∧
    -- (6) Circular shift invariance: if no slot is free in
    --     `[nextAsid, nextAsid + k)` (circularly), then searching from
    --     `nextAsid` and from `nextAsid + k` give the same result, with
    --     the distance reduced by exactly `k`.
    (∀ k : Nat, k < hwAsidCount →
      (∀ d : Fin hwAsidCount, d.val < k →
        (table ⟨(nextAsid.val + d.val) % hwAsidCount,
            Nat.mod_lt _ (by decide : 0 < hwAsidCount)⟩).isSome) →
      ∀ r d, out = some (r, d) → k ≤ d.val →
        findOptimized table
          ⟨(nextAsid.val + k) % hwAsidCount,
            Nat.mod_lt _ (by decide : 0 < hwAsidCount)⟩ =
        some (r, ⟨d.val - k, by
          have : d.val < hwAsidCount := d.isLt
          omega⟩)) ∧
    -- (7) Distance bound: `d.val < hwAsidCount` (trivially from `Fin`).
    (∀ r d, out = some (r, d) → d.val < hwAsidCount) ∧
    -- (8) Soundness: when `out = some (r, d)`, table at `r` is none.
    (∀ r d, out = some (r, d) → (table r).isNone) ∧
    -- (9) Local minimality: for every distance strictly less than `d`,
    --     the corresponding slot is busy.
    (∀ r d, out = some (r, d) →
      ∀ d' : Fin hwAsidCount, d'.val < d.val →
        (table ⟨(nextAsid.val + d'.val) % hwAsidCount,
            Nat.mod_lt _ (by decide : 0 < hwAsidCount)⟩).isSome) ∧
    -- (10) Option exclusivity.
    (out = none → ¬ ∃ r d, out = some (r, d)) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- === END: AUX ===

end seL4.FindFreeHWASID_HS
