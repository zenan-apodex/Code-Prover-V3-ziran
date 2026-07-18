import Mathlib

def List.sum (xs : List Nat) : Nat :=
match xs with
| [] => 0
| x::xs => x + xs.sum

def count_eligible_students (N M K : Nat) (student_data : List (List Nat)) : Nat :=
sorry



theorem count_eligible_students_empty_data
  {N M K : Nat} (h1 : N ≥ 1) (h2 : M ≥ 1) (h3 : K ≥ 1) :
  count_eligible_students N M K [] = 0 :=
sorry
