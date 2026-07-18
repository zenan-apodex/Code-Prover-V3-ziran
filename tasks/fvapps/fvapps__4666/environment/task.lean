import Mathlib

def sum : List Int → Int 
  | [] => 0
  | x::xs => x + sum xs

def array_plus_array (arr1 arr2 : List Int) : Int := sorry





theorem array_plus_array_associative (a b c : List Int) :
  array_plus_array (a ++ b) c = array_plus_array a (b ++ c) := sorry
