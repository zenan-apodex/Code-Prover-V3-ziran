import Mathlib

structure VowelIndex where
  val : Nat
  valid : val ≤ 4 := by sorry 

def absent_vowel (s : String) : VowelIndex := 
  sorry

def getVowel (i : Nat) : Char :=
  match i with
  | 0 => 'a'
  | 1 => 'e'
  | 2 => 'i'
  | 3 => 'o'
  | _ => 'u'

theorem output_is_valid_index {s : String} (h : s.length > 0) :
  (absent_vowel s).val ≤ 4 :=
  sorry

theorem identified_vowel_actually_missing {s : String} (h : s.length > 0) :
  let result := (absent_vowel s).val
  ¬ s.contains (getVowel result) :=
  sorry

theorem only_one_vowel_missing {s : String} (h : s.length > 0) :
  let vowels := "aeiou"
  let text_vowels_count := (List.filter (fun c => vowels.contains c) s.data).length
  text_vowels_count = 4 →
  ¬ s.contains (getVowel (absent_vowel s).val) :=
  sorry
