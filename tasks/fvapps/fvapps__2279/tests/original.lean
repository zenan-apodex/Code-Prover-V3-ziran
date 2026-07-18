import Mathlib

def gcd (a b : Nat) : Nat := sorry

theorem gcd_positive (a b : Nat) : a > 0 → b > 0 → gcd a b > 0 := sorry

theorem gcd_divides (a b : Nat) : a > 0 → b > 0 → 
  a % (gcd a b) = 0 ∧ b % (gcd a b) = 0 := sorry 

theorem gcd_symmetric (a b : Nat) : a > 0 → b > 0 → gcd a b = gcd b a := sorry

def isTriangle (a b c : Nat) : Bool := sorry

theorem triangle_inequality (a b c : Nat) : a > 0 → b > 0 → c > 0 →
  isTriangle a b c = true → 
    a + b > c ∧ b + c > a ∧ a + c > b := sorry

theorem triangle_symmetric (a b c : Nat) : a > 0 → b > 0 → c > 0 →
  isTriangle a b c = isTriangle b c a ∧ 
  isTriangle b c a = isTriangle c a b := sorry

def checkNumbersFriends (a b : Nat) : Bool := sorry

theorem not_self_friends (a : Nat) : a > 0 → 
  checkNumbersFriends a a = false := sorry

theorem friends_symmetric (a b : Nat) : a > 0 → b > 0 →
  checkNumbersFriends a b = checkNumbersFriends b a := sorry

def countLonelyNumbers (n : Nat) : Nat := sorry

theorem lonely_numbers_bounds (n : Nat) : n > 0 →
  countLonelyNumbers n ≤ n := sorry

theorem one_is_lonely : countLonelyNumbers 1 = 1 := sorry

def solveTestCases (nums : List Nat) : List Nat := sorry
