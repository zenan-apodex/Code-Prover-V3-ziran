import Mathlib

def List.sum (xs: List Int) : Int :=
  match xs with
  | [] => 0
  | x::rest => x + sum rest

def jobScheduling (startTimes endTimes profits: List Int) : Int :=
  sorry

theorem job_scheduling_basic_properties 
  (startTimes endTimes profits: List Int)
  (h1: startTimes.length = endTimes.length)
  (h2: endTimes.length = profits.length)
  (h3: ∀ i, i < startTimes.length → startTimes[i]! > 0)
  (h4: ∀ i, i < endTimes.length → endTimes[i]! > startTimes[i]!)
  (h5: ∀ i, i < profits.length → profits[i]! > 0) :
  let result := jobScheduling startTimes endTimes profits
  -- Result is non-negative
  result ≥ 0 ∧
  -- Result doesn't exceed sum of profits  
  result ≤ List.sum profits :=
  sorry

theorem job_scheduling_single_job
  (startTime endTime profit: Int)
  (h1: startTime > 0)
  (h2: endTime > startTime)
  (h3: profit > 0) :
  jobScheduling [startTime] [endTime] [profit] = profit :=
  sorry
