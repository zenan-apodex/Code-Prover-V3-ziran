import Mathlib

def List.sum : List Nat → Nat 
  | [] => 0
  | (x::xs) => x + sum xs

def stone_game_ii (piles : List Nat) : Nat :=
  sorry

theorem stone_game_ii_positive (piles : List Nat) 
  (h : piles.all (λ x => x > 0)) :
  stone_game_ii piles > 0 :=
sorry

theorem stone_game_ii_bounded (piles : List Nat) :
  stone_game_ii piles ≤ List.sum piles :=
sorry  

theorem stone_game_ii_singleton (pile : Nat) 
  (h : pile > 0) : 
  stone_game_ii [pile] = pile :=
sorry

theorem stone_game_ii_same_values (x : Nat)
  (h : x > 0) :
  stone_game_ii [x, x, x] ≤ 3 * x :=
sorry
