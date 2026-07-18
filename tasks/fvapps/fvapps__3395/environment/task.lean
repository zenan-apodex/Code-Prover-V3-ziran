import Mathlib

/-- Function that removes duplicate words from a string -/
def removeDuplicateWords (s : String) : String := sorry

/-- The output of removeDuplicateWords contains no duplicate words -/
theorem no_duplicates {s : String} :
  let result := removeDuplicateWords s
  let resultWords := (result.splitOn " ")
  List.Nodup resultWords := by sorry

/-- Words in the output appear in the same order as their first occurrence in the input -/
theorem preserves_order {s : String} :
  let inputWords := (s.splitOn " ")
  let outputWords := (removeDuplicateWords s).splitOn " " 
  ∀ w ∈ outputWords, 
    List.indexOf w inputWords = List.indexOf w inputWords := by sorry

/-- All words in the output appear in the input -/
theorem output_subset_input {s : String} :
  let inputWords := (s.splitOn " ")
  let outputWords := (removeDuplicateWords s).splitOn " "
  ∀ w ∈ outputWords, w ∈ inputWords := by sorry
