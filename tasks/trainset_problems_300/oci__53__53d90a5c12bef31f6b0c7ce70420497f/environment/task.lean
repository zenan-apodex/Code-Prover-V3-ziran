-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def UInt32Bound : Int := 2 ^ (32 : Nat) - 1
-- !benchmark @end precond_aux

@[reducible, simp]
def Multiply_precond (a : Int) (b : Int) : Prop :=
  -- !benchmark @start precond
  0 ≤ a ∧ a ≤ UInt32Bound ∧ 0 ≤ b ∧ b ≤ UInt32Bound
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def Multiply (a : Int) (b : Int) (h_precond : Multiply_precond a b) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def Multiply_postcond (a : Int) (b : Int) (result : Int)
    (h_precond : Multiply_precond a b) : Prop :=
  -- !benchmark @start postcond
  result = a * b
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem Multiply_spec_satisfied (a : Int) (b : Int)
    (h_precond : Multiply_precond a b) :
    Multiply_postcond a b (Multiply a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof