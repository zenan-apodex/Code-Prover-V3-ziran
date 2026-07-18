import Mathlib

structure Time where
  hours : Nat
  minutes : Nat
deriving Repr

def work_needed (project_minutes : Nat) (freelancers : List Time) : String :=
  sorry

theorem work_needed_output_valid (project_minutes : Nat) (freelancers : List Time) :
  let result := work_needed project_minutes freelancers
  (result = "Easy Money!" ∨ result.startsWith "I need to work") :=
  sorry

theorem work_needed_enough_help (project_minutes : Nat) (freelancers : List Time) :
  let total_available := freelancers.foldl (fun acc t => acc + t.hours * 60 + t.minutes) 0
  total_available ≥ project_minutes → 
  work_needed project_minutes freelancers = "Easy Money!" :=
  sorry

theorem work_needed_not_enough_help (project_minutes : Nat) (freelancers : List Time) :
  let total_available := freelancers.foldl (fun acc t => acc + t.hours * 60 + t.minutes) 0
  let deficit := project_minutes - total_available
  let deficit_hours := deficit / 60
  let deficit_minutes := deficit % 60
  total_available < project_minutes →
  work_needed project_minutes freelancers = s!"I need to work {deficit_hours} hour(s) and {deficit_minutes} minute(s)" :=
  sorry

theorem work_needed_zero_project (freelancers : List Time) :
  work_needed 0 freelancers = "Easy Money!" :=
  sorry

theorem work_needed_no_freelancers (project_minutes : Nat) :
  let hours := project_minutes / 60
  let minutes := project_minutes % 60
  work_needed project_minutes [] = s!"I need to work {hours} hour(s) and {minutes} minute(s)" :=
  sorry
