import Mathlib

def VALID_NOTES := ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]

def which_note (n : Nat) : String := sorry

theorem note_is_valid (n : Nat) (h : n > 0) : 
  which_note n ∈ VALID_NOTES := sorry 

theorem note_wraps_after_88 (n : Nat) (h : n > 0) :
  which_note n = which_note (n + 88) := sorry
