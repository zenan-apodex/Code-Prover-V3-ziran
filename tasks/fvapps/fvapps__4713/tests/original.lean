import Mathlib

structure Time where
  hours : Nat
  minutes : Nat

def isValidTime (t : Time) : Prop := 
  t.hours ≤ 23 ∧ t.minutes ≤ 59

def lateClock (digits : List Nat) : String :=
sorry

def toNat (c : Char) : Nat :=
sorry

def getDigit (s : String) (i : Nat) : Char :=
s.data.get! i

theorem late_clock_output_format 
  {digits : List Nat}
  (h : digits.length = 4)
  (h' : ∀ d ∈ digits, d ≤ 9)
  (h'' : ∃ t : Time, isValidTime t) :
  let result := lateClock digits
  (result.length = 5) ∧ 
  (getDigit result 2 = ':') ∧
  (getDigit result 0).isDigit ∧
  (getDigit result 1).isDigit ∧
  (getDigit result 3).isDigit ∧
  (getDigit result 4).isDigit :=
sorry

theorem late_clock_valid_time
  {digits : List Nat}
  (h : digits.length = 4)
  (h' : ∀ d ∈ digits, d ≤ 9)
  (h'' : ∃ t : Time, isValidTime t) :
  let result := lateClock digits
  let t : Time := {
    hours := toNat (getDigit result 0) * 10 + toNat (getDigit result 1)
    minutes := toNat (getDigit result 3) * 10 + toNat (getDigit result 4)
  }
  isValidTime t :=
sorry

theorem late_clock_uses_all_digits
  {digits : List Nat}
  (h : digits.length = 4)
  (h' : ∀ d ∈ digits, d ≤ 9)
  (h'' : ∃ t : Time, isValidTime t) :
  let result := lateClock digits
  let result_digits := [
    toNat (getDigit result 0),
    toNat (getDigit result 1),
    toNat (getDigit result 3),
    toNat (getDigit result 4)
  ]
  ∃ σ : Fin 4 → Fin 4, 
    (∀ a b : Fin 4, σ a = σ b → a = b) ∧ 
    (∀ b : Fin 4, ∃ a : Fin 4, σ a = b) ∧
    (∀ i : Fin 4, digits.get! i.val = result_digits.get! (σ i).val) :=
sorry
