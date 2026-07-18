import Mathlib

namespace ProfessorScores

def solve_professor_scores (n m : Nat) (questions : List (Nat × Nat × Nat)) : Nat :=
  sorry

theorem result_is_nonnegative (n m : Nat) (questions : List (Nat × Nat × Nat)) :
  solve_professor_scores n m questions ≥ 0 := sorry

theorem result_bounded_by_max (n m : Nat) (questions : List (Nat × Nat × Nat)) :
  solve_professor_scores n m questions ≤ 10 * (10 ^ questions.length) := sorry



theorem all_students_same_k (n k : Nat) :
  n > 0 → k > 0 → k ≤ 10 → solve_professor_scores n 1 [(1,n,k)] = 10 * k := sorry

end ProfessorScores
