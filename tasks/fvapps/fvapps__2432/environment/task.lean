import Mathlib

def List.sum : List Int → Int 
  | [] => 0
  | x::xs => x + List.sum xs

def cal_points (ops : List String) : Int := sorry





theorem cal_points_basic_two_numbers :
  cal_points ["5", "2"] = 7 := sorry

theorem cal_points_basic_double :
  cal_points ["1", "D"] = 3 := sorry

theorem cal_points_basic_plus :
  cal_points ["1", "2", "+"] = 6 := sorry
