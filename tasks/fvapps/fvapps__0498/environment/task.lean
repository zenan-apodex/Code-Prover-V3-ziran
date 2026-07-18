import Mathlib

def List.sum : List Nat → Nat
  | [] => 0
  | x::xs => x + List.sum xs

def rob_houses (nums: List Nat) : Nat := sorry

theorem rob_houses_non_negative (nums: List Nat) :
  rob_houses nums ≥ 0 := sorry

theorem rob_houses_maximum_possible (nums: List Nat) :
  rob_houses nums ≤ List.sum nums := sorry 

theorem rob_houses_empty :
  rob_houses [] = 0 := sorry

theorem rob_houses_single (x: Nat) :
  rob_houses [x] = x := sorry

theorem rob_houses_two_equal (x: Nat) :
  rob_houses [x, x] = x := sorry
