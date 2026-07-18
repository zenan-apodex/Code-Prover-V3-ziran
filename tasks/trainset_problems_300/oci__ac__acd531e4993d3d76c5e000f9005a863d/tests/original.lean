-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IsValidIpv4_precond (ip_address : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def IsValidIpv4 (ip_address : String) (h_precond : IsValidIpv4_precond ip_address) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsDecimalDigit (c : Char) : Prop :=
  c = '0' ∨ c = '1' ∨ c = '2' ∨ c = '3' ∨ c = '4' ∨
  c = '5' ∨ c = '6' ∨ c = '7' ∨ c = '8' ∨ c = '9'

def NoLeadingZeroUnlessSingle (s : String) : Prop :=
  s.length = 1 ∨ ∃ c rest, s.toList = c :: rest ∧ c ≠ '0'

def ValidIpv4Segment (seg : String) : Prop :=
  seg.length > 0 ∧
  seg.length ≤ 3 ∧
  (∀ c ∈ seg.toList, IsDecimalDigit c) ∧
  NoLeadingZeroUnlessSingle seg ∧
  (∃ n : Nat, seg.toNat? = some n ∧ n ≤ 255)
-- !benchmark @end postcond_aux


@[reducible, simp]
def IsValidIpv4_postcond (ip_address : String) (result : Bool)
    (h_precond : IsValidIpv4_precond ip_address) : Prop :=
  -- !benchmark @start postcond
  let parts := ip_address.splitOn "."
  (result = true) ↔
    parts.length = 4 ∧
    (∀ seg ∈ parts, ValidIpv4Segment seg)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem IsValidIpv4_spec_satisfied (ip_address : String)
    (h_precond : IsValidIpv4_precond ip_address) :
    IsValidIpv4_postcond ip_address (IsValidIpv4 ip_address h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof