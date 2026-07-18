import Mathlib

def List.sum : List Int → Int  
  | [] => 0
  | (x::xs) => x + List.sum xs

def List.sort : List Int → List Int := sorry

def find_missing (arr1 : List Int) (arr2 : List Int) : Int := sorry

theorem removing_element_gives_correct_difference 
  (arr : List Int) (elem : Int) :
  find_missing (arr ++ [elem]) arr = elem := sorry



theorem identical_arrays_difference_is_zero
  (arr : List Int) (h : arr ≠ []) :
  find_missing arr arr = 0 := sorry
