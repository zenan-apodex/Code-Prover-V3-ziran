/-
  seL4 Optimization Task: finaliseSlot — zombie reduction loop with
  cycle detection.
  Source: src/object/cnode.c:615-662

  finaliseSlot drains a slot's capability through a sequence of
  `finaliseCap → reduceZombie` steps until either the cap becomes Null
  or a self-cyclic zombie is encountered. Naive: recursive deletion.
  Optimized: iterative loop with explicit cycle detection.

  termination is via a strictly-decreasing measure on the
  zombie's slot count, with the cycle case as the only escape hatch.
  The model must prove termination as part of the spec.
-/
import Mathlib

namespace seL4.FinaliseSlot

-- === BEGIN: DEFINITIONS (provided) ===

abbrev SlotPtr := Nat

/-- A simplified cap for the finalisation loop. -/
inductive Cap where
  | null
  /-- Zombie cap: tracks remaining slots and the slot it lives in. -/
  | zombie (slots : Nat) (selfPtr : SlotPtr)
  /-- Some other live cap (untyped, cnode, endpoint, …). -/
  | other (id : Nat)
  deriving DecidableEq, Repr

/-- A slot table mapping slot pointers to caps. -/
abbrev SlotTable := SlotPtr → Cap

/-- One reduction step: applied to a zombie at slot `p`, returns the
    cap that should now occupy that slot together with the new total
    "remaining work" measure. The optimization assumes monotonicity:
    if the cap was a zombie with `n` slots, the next step returns
    either `null` (we're done), `zombie m _` with `m < n` (progress),
    or a self-cyclic zombie (we are stuck and must escape). -/
structure ReduceStep where
  /-- New cap after one step. -/
  next : Cap
  /-- True iff this step represents a self-cycle (no progress). -/
  cyclic : Bool

abbrev Reducer := Cap → ReduceStep

-- === END: DEFINITIONS ===

-- === BEGIN: PREDICATES (provided) ===

/-- A reducer is "well-behaved" iff every non-cyclic step on a zombie
    strictly decreases the slot count, and a `null` cap reduces to itself
    non-cyclically. -/
def wellBehaved (red : Reducer) : Prop :=
  (∀ n p, (red (Cap.zombie n p)).cyclic = false →
    ∃ m p', (red (Cap.zombie n p)).next = Cap.zombie m p' ∧ m < n ∨
            (red (Cap.zombie n p)).next = Cap.null) ∧
  (red Cap.null = ⟨Cap.null, false⟩)

/-- The result of finalisation: either `done` (cap reduced to null) or
    `cycled` (a self-cyclic zombie was encountered, with the residual). -/
inductive FinResult where
  | done
  | cycled (residual : Cap)
  deriving DecidableEq, Repr

-- === END: PREDICATES ===

-- === BEGIN: AXIOMS (provided) ===
-- No axioms.
-- === END: AXIOMS ===

-- === BEGIN: SPEC (provided) ===

/-- Iteratively reduce a cap to either `null` or a self-cyclic zombie.
    Must terminate without `partial` and without an explicit fuel
    parameter; use the well-foundedness of `wellBehaved` reducers. -/
def finaliseSlot (red : Reducer) (cap : Cap) (h_wb : wellBehaved red) :
    FinResult :=
-- === END: SPEC ===
-- === BEGIN: IMPLEMENTATION (editable) ===
  sorry
-- === END: IMPLEMENTATION ===

-- === BEGIN: THEOREM (provided) ===

theorem finaliseSlot_correct (red : Reducer) (h_wb : wellBehaved red) :
    -- (1) Null input ⇒ `done`.
    finaliseSlot red Cap.null h_wb = FinResult.done ∧
    -- (2) Other (non-zombie, non-null) caps that don't reduce trivially
    --     are not handled — the spec only considers zombie/null. We
    --     model "other" by saying: if the reducer maps `other` to null,
    --     `finaliseSlot` returns `done`.
    (∀ id, red (Cap.other id) = ⟨Cap.null, false⟩ →
      finaliseSlot red (Cap.other id) h_wb = FinResult.done) ∧
    -- (3) Zombie that reduces in one step to null ⇒ `done`.
    (∀ p, red (Cap.zombie 0 p) = ⟨Cap.null, false⟩ →
      finaliseSlot red (Cap.zombie 0 p) h_wb = FinResult.done) ∧
    -- (4) Cyclic zombie immediately ⇒ `cycled` with the residual
    --     equal to the cap one step from the input.
    (∀ n p, (red (Cap.zombie n p)).cyclic = true →
      finaliseSlot red (Cap.zombie n p) h_wb =
        FinResult.cycled (red (Cap.zombie n p)).next) ∧
    -- (5) Strict-progress invariant: if `red` never produces a cycle on
    --     any zombie of size ≤ n, then `finaliseSlot` of any such
    --     zombie returns `done`.
    (∀ n,
      (∀ m p, m ≤ n → (red (Cap.zombie m p)).cyclic = false) →
      ∀ p, finaliseSlot red (Cap.zombie n p) h_wb = FinResult.done) ∧
    -- (6) Determinism: the result is a function of the cap and the
    --     reducer alone (modulo well-behavedness).
    (∀ cap : Cap, ∀ h_wb' : wellBehaved red,
      finaliseSlot red cap h_wb = finaliseSlot red cap h_wb') ∧
    -- (7) Monotonicity in cycle behavior: if `red` and `red'` agree on
    --     all zombies up to slot count `n`, then `finaliseSlot` agrees
    --     on `Cap.zombie n p` for any `p`.
    (∀ red' : Reducer, ∀ h_wb' : wellBehaved red',
      ∀ n,
      (∀ m p, m ≤ n → red (Cap.zombie m p) = red' (Cap.zombie m p)) →
      ∀ p, finaliseSlot red (Cap.zombie n p) h_wb =
           finaliseSlot red' (Cap.zombie n p) h_wb') ∧
    -- (8) Bound: any non-cyclic computation finishes in at most `n+1`
    --     reductions when starting from `Cap.zombie n p` (encoded by
    --     the existence of a witness chain of caps `cap_0 = zombie n p,
    --     cap_1, …, cap_k = null` with `k ≤ n + 1`).
    (∀ n p,
      (∀ m q, m ≤ n → (red (Cap.zombie m q)).cyclic = false) →
      ∃ k, k ≤ n + 1 ∧
        ∃ chain : List Cap, chain.length = k + 1 ∧
          chain.head? = some (Cap.zombie n p) ∧
          chain.getLast? = some Cap.null) ∧
    -- (9) Iterate-consistency (positive): if `finaliseSlot` returns
    --     `done` on `Cap.zombie n p` and the first step is non-cyclic
    --     with next `Cap.zombie m p'`, then finalising `Cap.zombie m p'`
    --     must also return `done`. This forces the outer answer to
    --     reflect what happens *all the way down*, not just at one step.
    (∀ n p m p',
      (red (Cap.zombie n p)).cyclic = false →
      (red (Cap.zombie n p)).next = Cap.zombie m p' →
      finaliseSlot red (Cap.zombie n p) h_wb = FinResult.done →
      finaliseSlot red (Cap.zombie m p') h_wb = FinResult.done) ∧
    -- (10) Iterate-consistency (negative): if the first step is
    --      non-cyclic and the inner `(zombie m p')` does NOT finalise
    --      to `done`, then neither can the outer `(zombie n p)`. This
    --      catches single-step stubs that blindly report `done` on
    --      non-cyclic first steps regardless of what happens later.
    (∀ n p m p',
      (red (Cap.zombie n p)).cyclic = false →
      (red (Cap.zombie n p)).next = Cap.zombie m p' →
      finaliseSlot red (Cap.zombie m p') h_wb ≠ FinResult.done →
      finaliseSlot red (Cap.zombie n p) h_wb ≠ FinResult.done) ∧
    -- (11) Functional uniqueness: any function `f` satisfying (1)-(5) and (9)-(10)
    --      must agree with `finaliseSlot red` on all zombie inputs.
    (∀ f : Cap → FinResult,
      -- f maps null to done
      f Cap.null = FinResult.done →
      -- f maps non-cyclic zombie to done when reducer yields null
      (∀ n p, (red (Cap.zombie n p)).cyclic = false →
        (red (Cap.zombie n p)).next = Cap.null →
        f (Cap.zombie n p) = FinResult.done) →
      -- f maps cyclic zombie to cycled
      (∀ n p, (red (Cap.zombie n p)).cyclic = true →
        f (Cap.zombie n p) = FinResult.cycled (red (Cap.zombie n p)).next) →
      -- f satisfies full iterate-consistency: for a non-cyclic transition
      -- between two zombies, f returns the same result on both. This is
      -- the bidirectional analog of (9)/(10) and also propagates the
      -- `cycled` residual, which the one-directional `done`-only axioms
      -- alone do not pin down.
      (∀ n p m p', (red (Cap.zombie n p)).cyclic = false →
        (red (Cap.zombie n p)).next = Cap.zombie m p' →
        f (Cap.zombie n p) = f (Cap.zombie m p')) →
      -- then f agrees with finaliseSlot
      ∀ n p, f (Cap.zombie n p) = finaliseSlot red (Cap.zombie n p) h_wb) ∧
    -- (12) Null case cannot report a cycle result.
    finaliseSlot red Cap.null h_wb ≠ FinResult.cycled Cap.null := by
-- === END: THEOREM ===
-- === BEGIN: PROOF (editable) ===
  sorry
-- === END: PROOF ===

-- === BEGIN: AUX (editable) ===
-- === END: AUX ===

end seL4.FinaliseSlot
