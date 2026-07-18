import Mathlib

def solve_array_zeroes (n : Nat) (arr : List Int) : Nat :=
  sorry

def sum (xs : List Int) : Int :=
  match xs with
  | [] => 0
  | h :: t => h + sum t

theorem solve_array_zeroes_nonnegative (n : Nat) (arr : List Int) :
  solve_array_zeroes n arr ≥ 0 :=
sorry

theorem solve_array_zeroes_all_positives (n : Nat) (arr : List Int) :
  (List.all arr (fun x => x ≥ 0)) → solve_array_zeroes n arr = 0 :=
sorry
