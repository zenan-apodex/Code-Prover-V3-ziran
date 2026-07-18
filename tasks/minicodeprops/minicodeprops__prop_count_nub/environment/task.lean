import Mathlib

def count [DecidableEq α]: α -> List α -> Nat
  | _z, []    => 0
  | z,  x::xs => if x==z then (count z xs).succ else count z xs


def nub [DecidableEq α]: List α → List α
  | [] => []
  | x::xs => x::(nub (xs.filter (fun y => x != y)))
termination_by xs => xs.length
decreasing_by
  simp_wf
  rw [Nat.lt_succ]
  exact List.length_filter_le _ xs

theorem prop_count_nub (x: α) (xs: List α) [DecidableEq α] :
  x ∈ xs → (count x (nub xs) == 1):= by sorry
