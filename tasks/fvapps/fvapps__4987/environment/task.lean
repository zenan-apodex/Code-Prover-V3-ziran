import Mathlib

def how_many_years (date1 : String) (date2 : String) : Nat := sorry

theorem how_many_years_symmetric (date1 date2 : String) :
  how_many_years date1 date2 = how_many_years date2 date1 := sorry 

theorem how_many_years_same_date (date : String) :
  how_many_years date date = 0 := sorry

theorem how_many_years_nonnegative (date1 date2 : String) :
  how_many_years date1 date2 ≥ 0 := sorry
