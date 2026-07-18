-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def IsDecimalDigit (c : Char) : Prop :=
  '0' ≤ c ∧ c ≤ '9'

def ValidIpv4Segment (seg : String) : Prop :=
  seg.length > 0 ∧
  (∀ c ∈ seg.toList, IsDecimalDigit c) ∧
  (seg = "0" ∨ seg.toList.head? ≠ some '0') ∧
  ∃ n : Nat, seg.toNat? = some n ∧ n ≤ 255
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsValidIpv4_precond (ip : String) : Prop :=
  -- !benchmark @start precond
  1 ≤ ip.length ∧ ip.length ≤ 15
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def IsValidIpv4 (ip : String) (h_precond : IsValidIpv4_precond ip) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def IsValidIpv4_postcond (ip : String) (result : Bool)
    (h_precond : IsValidIpv4_precond ip) : Prop :=
  -- !benchmark @start postcond
  let parts := ip.splitOn "."
  (result = true) ↔
    parts.length = 4 ∧
    ∀ seg ∈ parts, ValidIpv4Segment seg
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem IsValidIpv4_spec_satisfied (ip : String)
    (h_precond : IsValidIpv4_precond ip) :
    IsValidIpv4_postcond ip (IsValidIpv4 ip h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof