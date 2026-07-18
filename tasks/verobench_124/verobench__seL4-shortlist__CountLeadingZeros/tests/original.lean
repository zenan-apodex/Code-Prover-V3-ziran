/-
  seL4 Haskell Spec Optimization: countLeadingZeros
  Original: O(w) — reverse + takeWhile + length on bit list
  Optimized: O(log w) — binary search / de Bruijn sequence

  Source: SEL4/Kernel/Thread.lhs:379-381
  Used by: getHighestPrio → chooseThread (scheduler hot path)
-/
import Mathlib

namespace seL4.CountLeadingZeros

-- === BEGIN: DEFINITIONS (provided) ===

/-- Word width parameter. -/
def wordBits : Nat := 64

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- CLZ returns correct count: all bits above position (wordBits - 1 - clz) are zero,
    and if clz < wordBits, the bit at position (wordBits - 1 - clz) is set. -/
def clzCorrect (w : BitVec wordBits) (result : Nat) : Prop :=
  result ≤ wordBits ∧
  (∀ i, wordBits - result ≤ i → i < wordBits → w.getLsbD i = false) ∧
  (result < wordBits → w.getLsbD (wordBits - 1 - result) = true)

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No axioms. clz32 is provided as a real definition below; you must
-- unfold it and reason about it from first principles.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

/-- 32-bit CLZ as a real definition, scanning bit positions from the MSB
    (bit 31) down to the LSB (bit 0). Returns 32 when `w = 0`. -/
def clz32Aux (w : BitVec 32) : Nat → Nat
  | 0       => 32
  | n + 1   => if w.getLsbD n then (31 - n) else clz32Aux w n

def clz32 (w : BitVec 32) : Nat := clz32Aux w 32

/-- High 32 bits of a 64-bit word. -/
def high32 (w : BitVec wordBits) : BitVec 32 :=
  BitVec.ofNat 32 (w.toNat / 2 ^ 32)

/-- Low 32 bits of a 64-bit word. -/
def low32 (w : BitVec wordBits) : BitVec 32 :=
  BitVec.ofNat 32 w.toNat

/-- Mandatory two-stage CLZ decomposition through `clz32`. -/
def clzVia32 (w : BitVec wordBits) : Nat :=
  let hi := high32 w
  let lo := low32 w
  if hi = 0 then 32 + clz32 lo else clz32 hi

/-- Optimized 64-bit CLZ built from `clz32`. -/
def clzOptimized (w : BitVec wordBits) : Nat :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem clz_correct (w : BitVec wordBits) :
    let r := clzOptimized w
    -- (0) Construction constraint: implementation must match clz32-composition.
    r = clzVia32 w ∧
    -- (a) The result satisfies the intrinsic CLZ predicate.
    clzCorrect w r ∧
    -- (b) Zero input ↔ result equals wordBits.
    (w = 0 ↔ r = wordBits) ∧
    -- (c) Result is always at most wordBits.
    r ≤ wordBits ∧
    -- (d) Monotone in the position of the highest set bit:
    --     if `w₁` has all the set bits of `w₂` plus possibly more
    --     leading bits, then `clzOptimized w₁ ≤ clzOptimized w₂`.
    (∀ w' : BitVec wordBits,
      (∀ i, i < wordBits → w'.getLsbD i = true → w.getLsbD i = true) →
      clzOptimized w ≤ clzOptimized w') ∧
    -- (e) Uniqueness: any natural number satisfying `clzCorrect w` equals `r`.
    (∀ k : Nat, clzCorrect w k → k = r) ∧
    -- (f) 32-bit split law: decomposition over high/low halves is exact.
    ((high32 w = 0 → r = 32 + clz32 (low32 w)) ∧
     (high32 w ≠ 0 → r = clz32 (high32 w))) ∧
    -- (g) Half-range classification by high-half emptiness.
    ((high32 w = 0 ∧ low32 w = 0) ↔ r = wordBits) ∧
    ((high32 w = 0 ∧ low32 w ≠ 0) ↔ 32 ≤ r ∧ r < wordBits) ∧
    ((high32 w ≠ 0) ↔ r < 32) ∧
    -- (h) Exact highest-set-bit witness when nonzero.
    (w ≠ 0 →
      ∃ i, i < wordBits ∧ w.getLsbD i = true ∧
        ∀ j, i < j → j < wordBits → w.getLsbD j = false ∧
        i = wordBits - 1 - r) := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- === END: AUX ===

end seL4.CountLeadingZeros
