import Mathlib

structure Count where
  vowels : Nat
  consonants : Nat
deriving Repr

def get_count (s : String := "") : Count :=
  sorry

theorem get_count_nonnegative (s : String) :
  let result := get_count s
  result.vowels ≥ 0 ∧ result.consonants ≥ 0 :=
  sorry

theorem get_count_sum_equals_letters (s : String) :
  let result := get_count s
  let letter_count := (s.data.filter Char.isAlpha).length
  result.vowels + result.consonants = letter_count :=
  sorry
