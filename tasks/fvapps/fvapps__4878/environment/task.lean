import Mathlib

inductive GeneratorState where
  | Created
  | Started
  | Finished
deriving BEq, Repr

def check_generator {α : Type} (g : List α) : GeneratorState :=
  sorry

theorem new_generator {α : Type} (xs : List α) :
  check_generator xs = GeneratorState.Created := by
  sorry

theorem started_generator {α : Type} (xs : List α) (h : xs ≠ []) :
  check_generator (xs.tail) = GeneratorState.Started := by
  sorry

theorem finished_generator {α : Type} (xs : List α) :
  check_generator ([] : List α) = GeneratorState.Finished := by
  sorry

theorem generator_sequence {α : Type} (xs : List α) :
  (check_generator xs = GeneratorState.Created) ∧
  (xs ≠ [] → check_generator (xs.tail) = GeneratorState.Started) ∧
  (check_generator ([] : List α) = GeneratorState.Finished) := by
  sorry

theorem range_generator (n : Nat) :
  (check_generator (List.range n) = GeneratorState.Created) ∧
  (n > 0 → check_generator (List.range n).tail = GeneratorState.Started) ∧
  (check_generator ([] : List Nat) = GeneratorState.Finished) := by
  sorry
