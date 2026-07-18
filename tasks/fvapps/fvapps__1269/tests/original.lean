import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | x::xs => x + sum xs

def List.sort : List Nat → List Nat := sorry

def solve_circle_rectangles (n : Nat) (A B : List Nat) : Nat := sorry

theorem result_less_than_inputs {n : Nat} {A B : List Nat} 
  (h1 : A.length = n) (h2 : B.length = n) :
  solve_circle_rectangles n A B ≤ List.sum A ∧ 
  solve_circle_rectangles n A B ≤ List.sum B := sorry

theorem result_non_negative {n : Nat} {A B : List Nat}
  (h1 : A.length = n) (h2 : B.length = n) :
  solve_circle_rectangles n A B ≥ 0 := sorry

theorem result_order_independent {n : Nat} {A B : List Nat}
  (h1 : A.length = n) (h2 : B.length = n) :
  solve_circle_rectangles n A B = 
  solve_circle_rectangles n A.reverse B.reverse := sorry

theorem result_is_sum_of_mins {n : Nat} {A B : List Nat}
  (h1 : A.length = n) (h2 : B.length = n) :
  solve_circle_rectangles n A B = 
  List.sum (List.map (fun (p : Nat × Nat) => min p.fst p.snd) 
    (List.zip (List.sort A) (List.sort B))) := sorry
