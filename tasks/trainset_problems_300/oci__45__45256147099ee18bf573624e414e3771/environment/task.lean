-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def IsPowerOfTwoInt (z : Int) : Prop :=
  ∃ k : Nat, z = (2 : Int) ^ k
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def NextPowerOf2_precond (n : Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ n
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def NextPowerOf2 (n : Int) (h_precond : NextPowerOf2_precond n) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def NextPowerOf2_postcond (n : Int) (result : Int)
    (h_precond : NextPowerOf2_precond n) : Prop :=
  -- !benchmark @start postcond
  IsPowerOfTwoInt result ∧
  result > n ∧
  ∀ m : Int, IsPowerOfTwoInt m → m > n → result ≤ m
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem NextPowerOf2_spec_satisfied (n : Int)
    (h_precond : NextPowerOf2_precond n) :
    NextPowerOf2_postcond n (NextPowerOf2 n h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof