import Mathlib

def add (nums : List Float) : Int := sorry

theorem add_returns_int (nums : List Float) :
  add nums = add nums := sorry

theorem add_empty_list :
  add [] = 0 := sorry

theorem add_single_number (x : Float) :
  add [x] = Int.ofNat (x.toUInt64.toNat) := sorry 

theorem add_weighted_sum (nums : List Float) (h : nums ≠ []) :
  ∃ w : Float, w = (nums.enum.foldl (fun acc p => acc + p.2/(Float.ofNat (p.1 + 1))) 0) ∧ 
  (w - Float.ofInt (add nums)).abs < 0.01 := sorry
