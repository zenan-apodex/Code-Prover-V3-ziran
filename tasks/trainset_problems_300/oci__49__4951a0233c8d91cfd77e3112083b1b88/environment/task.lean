-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def IsDecimalDigit (c : Char) : Prop :=
  c = '0' ∨ c = '1' ∨ c = '2' ∨ c = '3' ∨ c = '4' ∨
  c = '5' ∨ c = '6' ∨ c = '7' ∨ c = '8' ∨ c = '9'

def ValidIPv4Segment (seg : String) : Prop :=
  seg.length > 0 ∧
  (∀ c ∈ seg.toList, IsDecimalDigit c) ∧
  (∃ n : Nat, seg.toNat? = some n ∧ n ≤ 255) ∧
  (seg = "0" ∨ ¬ seg.startsWith "0")
-- !benchmark @end precond_aux

@[reducible, simp]
def ValidateIp_precond (ip : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def ValidateIp (ip : String) (h_precond : ValidateIp_precond ip) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def ValidateIp_postcond (ip : String) (result : Bool)
    (h_precond : ValidateIp_precond ip) : Prop :=
  -- !benchmark @start postcond
  let parts := ip.splitOn "."
  (result = true) ↔
    parts.length = 4 ∧
    ∀ seg ∈ parts, ValidIPv4Segment seg
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem ValidateIp_spec_satisfied (ip : String)
    (h_precond : ValidateIp_precond ip) :
    ValidateIp_postcond ip (ValidateIp ip h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof