import Mathlib

structure Interval where
  start : Int
  finish : Int
  deriving Repr

instance : Inhabited Interval where
  default := { start := 0, finish := 1 }

def employeeFreeTime (schedule : List (List Interval)) : List Interval :=
  sorry

variable (schedule : List (List Interval))
variable (result : List Interval := employeeFreeTime schedule)
variable (allIntervals : List Interval := schedule.join)

theorem free_time_sorted : 
  ∀ i : Nat, i + 1 < result.length → 
  (result[i]!).finish < (result[i+1]!).start :=
  sorry

theorem no_overlap_with_work :
  ∀ free work : Interval, 
  free ∈ result → work ∈ allIntervals → 
  ¬(free.start < work.finish ∧ work.start < free.finish) :=
  sorry

theorem valid_interval_bounds :
  ∀ i : Interval, i ∈ result → i.start < i.finish :=
  sorry
 
theorem continuous_work_valid_bounds (raw_times : List (List Int)) :
  let schedule := raw_times.map (λ times => times.map (λ t => { start := t, finish := t+1 }))
  let result := employeeFreeTime schedule
  ∀ i : Interval, i ∈ result → i.start < i.finish :=
  sorry
