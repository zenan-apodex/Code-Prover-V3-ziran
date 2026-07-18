import Mathlib

def College := String
deriving Repr

def determine_college (s: String) : College := sorry
def process_test_cases (cases: List String) : List College := sorry

theorem determine_college_case_insensitive (s: String) :
  determine_college s = determine_college (s.toUpper) ∧
  determine_college s = determine_college (s.toLower) := sorry

theorem process_test_cases_preserves_length (cases: List String) :
  (process_test_cases cases).length = cases.length := sorry

theorem determine_college_valid_output (s: String) :
  determine_college s = "Both" ∨ 
  determine_college s = "GCETTB" ∨
  determine_college s = "GCETTS" ∨ 
  determine_college s = "Others" := sorry

theorem determine_college_substring_behavior (s1 s2: String) : 
  determine_college (s1 ++ "berhampore" ++ s2 ++ "serampore") = "Both" ∧
  determine_college (s1 ++ "berhampore" ++ s2) = "GCETTB" ∧
  determine_college (s1 ++ "serampore" ++ s2) = "GCETTS" := sorry

theorem process_test_cases_valid_output (cases: List String) :
  ∀ r ∈ process_test_cases cases,
    r = "Both" ∨ r = "GCETTB" ∨ r = "GCETTS" ∨ r = "Others" := sorry
