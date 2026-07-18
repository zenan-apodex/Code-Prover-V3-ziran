import Mathlib

structure NumberClass where
  value : String → Nat
  toString : Nat → String

def BinClass : NumberClass := sorry
def HexClass : NumberClass := sorry

theorem bin_str_roundtrip (s : String) : 
  s.any (fun c => c = '0' ∨ c = '1') → 
  BinClass.value (BinClass.toString (BinClass.value s)) = BinClass.value s := sorry

theorem bin_int_str_roundtrip (n : Nat) :
  BinClass.value (BinClass.toString n) = n := sorry 

theorem bin_arithmetic_add (s1 s2 : String) :
  BinClass.value s1 + BinClass.value s2 = BinClass.value (BinClass.toString (BinClass.value s1 + BinClass.value s2)) := sorry

theorem bin_arithmetic_mul (s1 s2 : String) :
  BinClass.value s1 * BinClass.value s2 = BinClass.value (BinClass.toString (BinClass.value s1 * BinClass.value s2)) := sorry

theorem bin_arithmetic_div (s1 s2 : String) :
  BinClass.value s2 ≠ 0 →
  BinClass.value s1 / BinClass.value s2 = BinClass.value (BinClass.toString (BinClass.value s1 / BinClass.value s2)) := sorry

theorem bin_arithmetic_sub (s1 s2 : String) :
  BinClass.value s1 ≥ BinClass.value s2 →
  BinClass.value s1 - BinClass.value s2 = BinClass.value (BinClass.toString (BinClass.value s1 - BinClass.value s2)) := sorry

theorem base_conversion (n : Nat) :
  BinClass.value (BinClass.toString n) = HexClass.value (HexClass.toString n) := sorry

theorem arbitrary_base_conversion {α : Type} (s : List α) (n : Nat) [DecidableEq α] :
  s.length > 1 →
  ∃ (NumClass : NumberClass),
  NumClass.value (NumClass.toString n) = n := sorry
