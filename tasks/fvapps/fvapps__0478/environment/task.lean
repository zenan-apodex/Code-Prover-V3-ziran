import Mathlib

def single_number (nums : List Int) : Int :=
  sorry

theorem single_number_minimal (val : Int) :
  val ≥ -1000 → val ≤ 1000 →
  single_number ([val, val, val, val + 1]) = val + 1 :=
sorry

theorem single_number_reorder_invariant (single_val : Int) (others : List Int) :
  single_number (single_val :: (others.map (λ x => [x,x,x])).join) = 
  single_number ((others.map (λ x => [x,x,x])).join ++ [single_val]) :=
sorry

theorem single_number_triple_plus_one (val : Int) :
  val ≥ -1000 → val ≤ 1000 →
  let nums := (List.replicate 3 val) ++ [val + 1]
  (single_number nums = val + 1) ∧ 
  (nums.count (single_number nums) = 1) ∧
  (∀ x, x ∈ nums → x ≠ single_number nums → nums.count x = 3) :=
sorry
