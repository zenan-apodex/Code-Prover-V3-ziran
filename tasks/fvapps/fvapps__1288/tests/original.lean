import Mathlib

def min_employees_to_inform (n : Nat) (pairs : List (Nat × Nat)) : Nat := sorry





theorem line_formation (n : Nat) (h : 2 ≤ n) 
  (pairs : List (Nat × Nat))
  (h_pairs : pairs = List.map (fun i => (i, i+1)) (List.range (n-1))) :
  min_employees_to_inform n pairs ≤ (n + 1) / 2 := sorry

theorem star_formation (n : Nat) (h : 2 ≤ n)
  (pairs : List (Nat × Nat))
  (h_pairs : pairs = List.map (fun i => (1, i+2)) (List.range (n-1))) :
  min_employees_to_inform n pairs = 1 := sorry

theorem fully_connected (n : Nat) (h : 3 ≤ n)
  (pairs : List (Nat × Nat))
  (h_pairs : pairs = List.join (List.map 
    (fun i => List.map (fun j => (i,j)) (List.range' (i+1) (n+1))) 
    (List.range' 1 n))) :
  min_employees_to_inform n pairs = 1 := sorry
