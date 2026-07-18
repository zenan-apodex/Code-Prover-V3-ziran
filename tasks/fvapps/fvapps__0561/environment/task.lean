import Mathlib

def List.sum : List Nat → Nat
  | [] => 0
  | (x::xs) => x + List.sum xs

def List.sort : List Nat → List Nat := sorry

def can_spend_all_money (n : Nat) (k : Nat) (demands : List Nat) : Bool :=
  sorry

theorem can_spend_all_money_sum_too_large {n : Nat} {k : Nat} {demands : List Nat} :
  k > List.sum demands → can_spend_all_money n k demands = false :=
  sorry

theorem can_spend_all_money_sort_invariant {n : Nat} {k : Nat} {demands : List Nat} :
  can_spend_all_money n k (List.sort demands) = can_spend_all_money n k demands :=
  sorry

theorem can_spend_individual_demands {n : Nat} {demands : List Nat} :
  ∀ d ∈ demands, can_spend_all_money n d demands = true :=
  sorry
