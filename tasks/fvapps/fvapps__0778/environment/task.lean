import Mathlib

def reverse_numbers (nums : List String) : List Int := sorry

def is_palindrome (s : String) : Bool := sorry

theorem reverse_numbers_preserves_length {nums : List String} :
  List.length (reverse_numbers nums) = List.length nums := sorry
