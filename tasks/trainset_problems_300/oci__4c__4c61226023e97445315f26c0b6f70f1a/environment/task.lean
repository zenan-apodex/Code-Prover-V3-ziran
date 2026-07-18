-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def RomanThousands (s : String) (n : Int) : Prop :=
  (n = 0 ∧ s = "") ∨
  (n = 1 ∧ s = "M") ∨
  (n = 2 ∧ s = "MM") ∨
  (n = 3 ∧ s = "MMM")

def RomanHundreds (s : String) (n : Int) : Prop :=
  (n = 0 ∧ s = "") ∨
  (n = 1 ∧ s = "C") ∨
  (n = 2 ∧ s = "CC") ∨
  (n = 3 ∧ s = "CCC") ∨
  (n = 4 ∧ s = "CD") ∨
  (n = 5 ∧ s = "D") ∨
  (n = 6 ∧ s = "DC") ∨
  (n = 7 ∧ s = "DCC") ∨
  (n = 8 ∧ s = "DCCC") ∨
  (n = 9 ∧ s = "CM")

def RomanTens (s : String) (n : Int) : Prop :=
  (n = 0 ∧ s = "") ∨
  (n = 1 ∧ s = "X") ∨
  (n = 2 ∧ s = "XX") ∨
  (n = 3 ∧ s = "XXX") ∨
  (n = 4 ∧ s = "XL") ∨
  (n = 5 ∧ s = "L") ∨
  (n = 6 ∧ s = "LX") ∨
  (n = 7 ∧ s = "LXX") ∨
  (n = 8 ∧ s = "LXXX") ∨
  (n = 9 ∧ s = "XC")

def RomanOnes (s : String) (n : Int) : Prop :=
  (n = 0 ∧ s = "") ∨
  (n = 1 ∧ s = "I") ∨
  (n = 2 ∧ s = "II") ∨
  (n = 3 ∧ s = "III") ∨
  (n = 4 ∧ s = "IV") ∨
  (n = 5 ∧ s = "V") ∨
  (n = 6 ∧ s = "VI") ∨
  (n = 7 ∧ s = "VII") ∨
  (n = 8 ∧ s = "VIII") ∨
  (n = 9 ∧ s = "IX")
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def IntToRoman_precond (num : Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ num ∧ num ≤ 3999
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def IntToRoman (num : Int) (h_precond : IntToRoman_precond num) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def IntToRoman_postcond (num : Int) (result : String)
    (h_precond : IntToRoman_precond num) : Prop :=
  -- !benchmark @start postcond
  ∃ th h t o : Int,
    0 ≤ th ∧ th ≤ 3 ∧
    0 ≤ h ∧ h ≤ 9 ∧
    0 ≤ t ∧ t ≤ 9 ∧
    0 ≤ o ∧ o ≤ 9 ∧
    num = 1000 * th + 100 * h + 10 * t + o ∧
    ∃ sTh sH sT sO : String,
      RomanThousands sTh th ∧
      RomanHundreds sH h ∧
      RomanTens sT t ∧
      RomanOnes sO o ∧
      result = sTh ++ sH ++ sT ++ sO
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem IntToRoman_spec_satisfied (num : Int)
    (h_precond : IntToRoman_precond num) :
    IntToRoman_postcond num (IntToRoman num h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof