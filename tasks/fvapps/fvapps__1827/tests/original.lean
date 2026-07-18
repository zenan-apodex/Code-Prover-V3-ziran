import Mathlib

namespace Nat
  def log (base n : Nat) : Nat := sorry
end Nat

def smallest_good_base (n : String) : String :=
sorry

theorem smallest_good_base_result_bounds {n : Nat} (h1 : n ≥ (3 : Nat)) (h2 : n ≤ Nat.pow 10 18) :
  let result := String.toNat! (smallest_good_base (toString n))
  result ≥ (2 : Nat) ∧ result < n :=
sorry

theorem smallest_good_base_all_ones {n : Nat} (h1 : n ≥ (3 : Nat)) (h2 : n ≤ Nat.pow 10 18) :
  let result := String.toNat! (smallest_good_base (toString n))
  let m := Nat.log result n
  (Nat.pow result (m+1) - 1)/(result - 1) = n :=
sorry

theorem smallest_good_base_min_input :
  smallest_good_base "3" = "2" :=
sorry

theorem smallest_good_base_power_two_minus_one :
  smallest_good_base "15" = "2" :=
sorry
