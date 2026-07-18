import Mathlib

def List.sum (xs : List Int) : Int :=
  match xs with
  | [] => 0
  | x::xs => x + xs.sum

def Int.toFloat (i : Int) : Float :=
  Float.ofInt i

structure BillDict where
  keys : List String 
  values : List Int
  size : Nat

def split_the_bill (bill : BillDict) : BillDict :=
  sorry

theorem split_bill_preserves_keys (bill : BillDict) :
  (split_the_bill bill).keys = bill.keys := by
  sorry

theorem split_bill_preserves_differences (bill : BillDict) (k : String) :
  k ∈ bill.keys →
  let mean := (bill.values.sum.toFloat) / (Float.ofNat bill.size)
  k ∈ (split_the_bill bill).keys →
  let orig_val := bill.values[bill.keys.indexOf k]!
  let new_val := (split_the_bill bill).values[bill.keys.indexOf k]!
  new_val.toFloat = orig_val.toFloat - mean := by
  sorry

theorem split_bill_input_size_bounds (bill : BillDict) :
  2 ≤ bill.size ∧ bill.size ≤ 10 →
  (∀ v ∈ bill.values, 0 ≤ v ∧ v ≤ 1000) →
  (split_the_bill bill).size = bill.size := by
  sorry
