import Mathlib

def roundRobin (jobs : List Nat) (slice : Nat) (target : Nat) : Nat := sorry

def List.sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + List.sum xs

theorem roundRobin_lower_bound {jobs : List Nat} {slice : Nat} (h : jobs.length > 0) :
  roundRobin jobs slice 0 ≥ jobs.get! 0 := by sorry

theorem roundRobin_upper_bound {jobs : List Nat} {slice : Nat} (h : jobs.length > 0) :
  roundRobin jobs slice 0 ≤ List.sum jobs := by sorry

theorem roundRobin_single_job {job : Nat} {slice : Nat} :
  roundRobin [job] slice 0 = job := by sorry
