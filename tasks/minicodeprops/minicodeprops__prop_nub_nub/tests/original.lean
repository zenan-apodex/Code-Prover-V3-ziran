import Mathlib

def nub [DecidableEq α]: List α → List α
  | [] => []
  | x::xs => x::(nub (xs.filter (fun y => x != y)))
termination_by xs => xs.length
decreasing_by
  simp_wf
  rw [Nat.lt_succ]
  exact List.length_filter_le _ xs

theorem prop_nub_nub (xs: List α) [DecidableEq α] :
  nub (nub xs) == nub xs:= by sorry
