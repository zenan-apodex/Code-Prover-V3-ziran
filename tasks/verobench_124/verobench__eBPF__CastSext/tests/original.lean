/-
  BPF cast verification task: Sign Extension
  Operator: SEXT

  Compute the optimal abstract state for the result of
  sign-extending the low size*8 bits to 64 bits (coerce_reg_to_size_sx) on a single abstract register state,
  parameterized by byte width.
  The result must be the best abstract transformer (α ∘ f ∘ γ).
-/
import Mathlib

namespace BPF

-- === BEGIN: DEFINITIONS (provided) ===

/-- A tnum represents a set of 64-bit values:
    known bits are fixed by `value`, unknown bits are indicated by `mask`. -/
structure Tnum where
  value : BitVec 64
  mask  : BitVec 64

/-- Abstract register state tracking value ranges and tnum constraint. -/
structure RegState where
  umin_value    : BitVec 64
  umax_value    : BitVec 64
  smin_value    : BitVec 64
  smax_value    : BitVec 64
  u32_min_value : BitVec 32
  u32_max_value : BitVec 32
  s32_min_value : BitVec 32
  s32_max_value : BitVec 32
  var_off       : Tnum

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- A value `x` satisfies a 64-bit tnum constraint. -/
def satisfiesTnum64 (x tval tmask : BitVec 64) : Prop :=
  (x &&& ~~~tmask) = tval

/-- A concrete value `x` is in the gamma (concretization) of a register state
    iff it satisfies ALL five constraints: u64 range, s64 range,
    u32 range, s32 range, and tnum. -/
def inGamma (reg : RegState) (x : BitVec 64) : Prop :=
  -- unsigned 64-bit range
  reg.umin_value ≤ x ∧ x ≤ reg.umax_value ∧
  -- signed 64-bit range
  reg.smin_value.toInt ≤ x.toInt ∧ x.toInt ≤ reg.smax_value.toInt ∧
  -- unsigned 32-bit range
  reg.u32_min_value ≤ x.truncate 32 ∧ (x.truncate 32 : BitVec 32) ≤ reg.u32_max_value ∧
  -- signed 32-bit range
  reg.s32_min_value.toInt ≤ (x.truncate 32 : BitVec 32).toInt ∧
    (x.truncate 32 : BitVec 32).toInt ≤ reg.s32_max_value.toInt ∧
  -- tnum constraint
  satisfiesTnum64 x reg.var_off.value reg.var_off.mask

/-- A register state is valid if all ranges are well-formed and
    consistent with the tnum. -/
def validReg (reg : RegState) : Prop :=
  reg.umin_value ≤ reg.umax_value ∧
  reg.smin_value.toInt ≤ reg.smax_value.toInt ∧
  reg.u32_min_value ≤ reg.u32_max_value ∧
  reg.s32_min_value.toInt ≤ reg.s32_max_value.toInt ∧
  (reg.var_off.value &&& reg.var_off.mask) = 0 ∧
  reg.var_off.value ≤ reg.umin_value ∧
  reg.umax_value ≤ (reg.var_off.value ||| reg.var_off.mask)

-- === END: PREDICATES ===

-- === BEGIN: SPEC (provided) ===

/-- The concrete cast operation, parameterized by size in bytes (1, 2, or 4). -/
def concreteSext (x : BitVec 64) (size : Nat) : BitVec 64 :=
  let mask := ((1 : BitVec 64) <<< (size * 8)) - 1
  let signBit := (1 : BitVec 64) <<< (size * 8 - 1)
  let low := x &&& mask
  if (low &&& signBit) ≠ 0 then low ||| ~~~mask else low

/-- Compute the optimal abstract state for Sign Extension. -/
def castSext (reg : RegState) (size : Nat) : RegState :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry

-- === END: IMPLEMENTATION ===

-- === BEGIN: SPEC_CORRECT (provided) ===

theorem castSext_correct (reg : RegState) (size : Nat)
    (hv : validReg reg)
    (hne : ∃ x, inGamma reg x)
    (hsize : size = 1 ∨ size = 2 ∨ size = 4) :
    let r := castSext reg size
    -- Well-formedness: result is a valid register state
    validReg r ∧
    -- Soundness: every concrete result is in γ(r)
    (∀ x, inGamma reg x → inGamma r (concreteSext x size)) ∧
    -- Optimality: r is the ⊑-least sound abstraction (best abstract transformer)
    (∀ r' : RegState, validReg r' →
      (∀ x, inGamma reg x → inGamma r' (concreteSext x size)) →
      (∀ v, inGamma r v → inGamma r' v)) := by
-- === END: SPEC_CORRECT ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- === END: AUX ===

end BPF
