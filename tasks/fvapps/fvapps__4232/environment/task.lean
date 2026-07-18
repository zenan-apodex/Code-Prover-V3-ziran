import Mathlib

def convert_to_mixed_numeral (fraction : String) : MixedNumeral := sorry

structure MixedNumeral where
  whole : Int
  numer : Nat
  denom : Nat
  deriving Repr

theorem mixed_numeral_format 
  (n d : Int)
  (h1 : d > 0)
  (result : MixedNumeral) 
  (h2 : result = convert_to_mixed_numeral ("{n}/{d}")) :
  (result.numer = 0 ∧ result.denom = 1 ∧ result.whole = n / d) ∨ 
  (result.whole = 0 ∧ result.numer = n.natAbs ∧ result.denom = d.natAbs) ∨
  (0 < result.numer ∧ 
   result.numer < result.denom ∧
   result.whole * result.denom + result.numer * (if result.whole ≥ 0 then 1 else -1) = n ∧
   result.denom = d.natAbs) := sorry

theorem value_equivalence
  (n d : Int)
  (h1 : d > 0)
  (result : MixedNumeral)
  (h2 : result = convert_to_mixed_numeral ("{n}/{d}")) : 
  n / d = result.whole + result.numer / result.denom * (if result.whole ≥ 0 then 1 else -1) := sorry
