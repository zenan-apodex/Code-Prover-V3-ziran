import Mathlib

namespace CheckSequence

def check (seq : List α) (elem : α) : Bool :=
  sorry

theorem check_membership_true {α} (seq : List α) (elem : α) :
  elem ∈ seq → check seq elem = true := by
  sorry

theorem check_membership_false {α} (seq : List α) (elem : α) :
  elem ∉ seq → check seq elem = false := by
  sorry

theorem check_reflexive {α} (seq : List α) (elem : α) :
  check (seq ++ [elem]) elem = true := by
  sorry

end CheckSequence
