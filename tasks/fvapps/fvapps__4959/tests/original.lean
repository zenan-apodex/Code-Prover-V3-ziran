import Mathlib

inductive Weigh
  | Left
  | Right
  | Equal
deriving BEq, Repr

structure MockScales where
  heavyIdx : Nat

def weighBalls (scales : MockScales) (left right : List Nat) : Weigh := sorry

def find_ball (scales : MockScales) (n : Nat) : Nat := sorry 

theorem find_ball_correct 
  (n : Nat)
  (heavy_idx : Nat)
  (h₁ : 0 < n)
  (h₂ : heavy_idx < n) :
  find_ball (MockScales.mk heavy_idx) n = heavy_idx := sorry

theorem find_ball_complexity
  (n : Nat)
  (heavy_idx : Nat)
  (h₁ : 0 < n) 
  (h₂ : heavy_idx < n) :
  ∃ uses : Nat, uses ≤ max 1 (Nat.log2 n) := sorry

theorem find_ball_edge_cases
  (n : Nat)
  (h : 0 < n) :
  find_ball (MockScales.mk 0) n = 0 ∧ 
  find_ball (MockScales.mk (n-1)) n = n-1 := sorry
