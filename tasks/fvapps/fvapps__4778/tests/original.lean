import Mathlib

structure Student where
  name : String
  fives : Nat
  tens : Nat
  twenties : Nat
deriving Repr

def total_money (s : Student) : Nat :=
  s.fives * 5 + s.tens * 10 + s.twenties * 20

def most_money (students : List Student) : String :=
  sorry

theorem most_money_valid_result {students : List Student} (h : students ≠ []) :
  let result := most_money students
  (students.length = 1 → result = (students.head h).name) ∧
  (students.length > 1 → result = "all" ∨ ∃ s ∈ students, result = s.name) :=
sorry

theorem all_equal_returns_all {students : List Student} (h1 : students ≠ []) 
  (h2 : ∀ s ∈ students, total_money s = total_money (students.head h1)) :
  most_money students = "all" :=
sorry

def find_max_student (students : List Student) : Student :=
  sorry

theorem highest_total_wins {students : List Student} (h : students ≠ []) :
  let result := most_money students
  let max_student := find_max_student students
  result ≠ "all" → result = max_student.name :=
sorry
