import Mathlib

def List.sum [Add α] : List α → α 
  | [] => sorry
  | (x::xs) => x + List.sum xs

def max_city_score (n : Nat) (m : Nat) (weights : List Nat) (roads : List (Nat × Nat)) (start : Nat) : Nat :=
sorry

theorem max_city_score_lower_bound (n : Nat) (weights : List Nat) (start : Nat)
  (h1 : n > 0)
  (h2 : weights.length = n) 
  (h3 : start > 0)
  (h4 : start ≤ n) :
  let roads := List.range (n-1) |>.map (λ i => (i+1, i+2))
  let result := max_city_score n (n-1) weights roads start
  result ≥ weights[start-1] := sorry

theorem max_city_score_upper_bound (n : Nat) (weights : List Nat) (start : Nat)
  (h1 : n > 0)
  (h2 : weights.length = n)
  (h3 : start > 0)
  (h4 : start ≤ n) :
  let roads := List.range (n-1) |>.map (λ i => (i+1, i+2))
  let result := max_city_score n (n-1) weights roads start
  result ≤ List.sum weights := sorry

theorem single_city_case (weight : Nat) :
  max_city_score 1 0 [weight] [] 1 = weight := sorry

theorem line_graph_path_sum (n : Nat) (weights : List Nat) (start : Nat)
  (h1 : n ≥ 2)
  (h2 : weights.length = n)
  (h3 : start > 0)
  (h4 : start ≤ n) :
  let roads := List.range (n-1) |>.map (λ i => (i+1, i+2))
  let result := max_city_score n (n-1) weights roads start
  let path_sum := List.sum (List.drop (start-1) weights)
  result ≥ path_sum := sorry
