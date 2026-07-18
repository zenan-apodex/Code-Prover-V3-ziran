import Mathlib

def valid (schedule : List (List (List Char))) : Bool :=
  sorry

theorem empty_or_valid_structure
  (schedule : List (List (List Char))) :
  (schedule = [] ∨ (∃ day ∈ schedule, day = [])) → valid schedule ∧
  valid schedule →
    (∀ day ∈ schedule,
      (∀ day' ∈ schedule, day.length = day'.length) ∧
      (∀ group ∈ day, ∀ group' ∈ day, group.length = group'.length)) :=
  sorry

theorem single_day_valid
  (schedule : List (List (List Char))) :
  schedule.length = 1 →
  valid schedule →
  ∀ day ∈ schedule,
    let golfers := List.join day
    ∀ golfer ∈ golfers,
      List.length (List.filter (List.elem golfer) day) = 1 :=
  sorry

theorem multi_day_valid
  (schedule : List (List (List Char))) :
  schedule.length > 1 →
  valid schedule →
  let golfers := List.join (List.head! schedule)
  (∀ day ∈ schedule, List.join day = golfers) ∧
  (∀ g1 ∈ golfers,
   ∀ g2 ∈ golfers,
   g1 ≠ g2 →
   ∀ day1 ∈ schedule,
   ∀ group1 ∈ day1,
   group1.contains g1 ∧ group1.contains g2 →
   ∀ day2 ∈ schedule,
   ∀ group2 ∈ day2,
   day1 ≠ day2 →
   ¬(group2.contains g1 ∧ group2.contains g2)) :=
  sorry
