import Mathlib

structure NonNegFloat where
  val : Float
  isNonNeg : val ≥ 0

def graceful_tipping (bill : NonNegFloat) : Float := sorry

theorem tip_at_least_15_percent (bill : NonNegFloat) 
  (h1 : bill.val ≥ 0.01) 
  (h2 : bill.val ≤ 10000) :
  graceful_tipping bill ≥ bill.val * 1.15 := sorry

theorem result_is_clean_number (bill : NonNegFloat)
  (h1 : bill.val ≥ 0.01)
  (h2 : bill.val ≤ 10000) :
  let result := graceful_tipping bill
  let intResult := Float.toUInt64 result 
  (bill.val * 1.15 ≥ 10 →
    let magnitude := UInt64.ofNat (10 ^ (String.length (toString intResult) - 1))
    intResult % (magnitude / 2) = 0) := sorry
