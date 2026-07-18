import Mathlib

def find (seq : List Int) : Int := sorry

theorem find_simple_sequence
    (start : Int) :
    find [start, start + 2, start + 6] = start + 4 := sorry

theorem find_symmetric_sequence
    (center : Int) :
    find [center - 4, center - 2, center + 2, center + 4] = center := sorry
