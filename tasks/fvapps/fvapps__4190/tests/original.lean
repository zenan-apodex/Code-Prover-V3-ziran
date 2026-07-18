import Mathlib

def VOWELS : List Char := ['a', 'e', 'i', 'o', 'u']

def isVowel (c : Char) : Bool := c ∈ VOWELS 

def is_alt (s : String) : Bool := sorry

theorem matches_reference_implementation (s : String) : 
  is_alt s = (if s.isEmpty then true
             else let pairs := s.toList.zip (s.toList.tail!)
                  pairs.all (fun p => isVowel p.fst ≠ isVowel p.snd)) := 
  sorry

theorem consecutive_vowels_false {s : String} (h : s.length ≥ 2) 
  (h2 : ∀ c ∈ s.toList, isVowel c) : 
  ¬(is_alt s) :=
  sorry

theorem consecutive_consonants_false {s : String} (h : s.length ≥ 2)
  (h2 : ∀ c ∈ s.toList, ¬(isVowel c)) :
  ¬(is_alt s) := 
  sorry

theorem alternating_pattern_true {s : String} (h : ∀ c ∈ s.toList, ¬(isVowel c)) :
  let result := s.toList.enum.map (fun (i, c) => if i % 2 = 0 then c else 'a')
  is_alt (String.mk result) :=
  sorry
