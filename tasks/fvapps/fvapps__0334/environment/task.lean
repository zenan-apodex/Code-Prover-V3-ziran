import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | x::xs => x + sum xs

def min_cost (s : String) (cost : List Nat) : Nat := sorry

def is_valid_result (s : String) (cost : List Nat) (result : Nat) : Bool := sorry

theorem min_cost_properties {s : String} {cost : List Nat} 
  (h : cost.length = s.length) :
  let result := min_cost s cost
  (result ≥ 0) ∧ 
  (result ≤ List.sum cost) ∧
  (is_valid_result s cost result = true) :=
sorry

theorem same_chars_cost {s : String} {cost : List Nat}
  (h1 : cost.length = s.length)
  (h2 : ∀ (i j : String.Pos), s.get i = s.get j)
  (h3 : ∀ (i : Fin cost.length), cost.get i = i.val + 1) :
  min_cost s cost = List.sum (cost.take (cost.length - 1)) :=
sorry

theorem unique_chars_zero_cost {s : String} {cost : List Nat}
  (h1 : cost.length = s.length) 
  (h2 : ∀ (i j : String.Pos), i ≠ j → s.get i ≠ s.get j)
  (h3 : ∀ (i : Fin cost.length), cost.get i = i.val + 1) :
  min_cost s cost = 0 :=
sorry
