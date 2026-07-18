import Mathlib

structure ExamTask where
  time : Nat 
  type : Nat
deriving Repr

abbrev Tasks := List ExamTask

def solve_exam_problems (n : Nat) (T : Nat) (a : Nat) (b : Nat) (tasks : Tasks) (total_a total_b : Nat) : Nat :=
  sorry

theorem solve_exam_problems_bounds {n T a b : Nat} {tasks : Tasks} {total_a total_b : Nat}
  (n_pos : n > 0) (T_pos : T > 0) (a_pos : a > 0) (b_pos : b > 0) :
  let result := solve_exam_problems n T a b tasks total_a total_b
  result ≤ total_a + total_b ∧ result ≥ 0 :=
sorry

theorem solve_empty_tasks {n T a b : Nat}
  (n_pos : n > 0) (T_pos : T > 0) (a_pos : a > 0) (b_pos : b > 0) :
  solve_exam_problems n T a b [] 0 0 = 0 :=
sorry

theorem solve_zero_time {n a b : Nat} {tasks : Tasks}
  (n_pos : n > 0) (a_pos : a > 0) (b_pos : b > 0) :
  solve_exam_problems n 0 a b tasks 1 0 = 0 :=
sorry
