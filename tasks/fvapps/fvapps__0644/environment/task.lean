import Mathlib

def List.sum : List Nat → Nat 
| [] => 0
| (h :: t) => h + sum t

def can_share_candies (n_friends : Nat) (candies : List Nat) : String := sorry

theorem can_share_candies_valid_output (n_friends : Nat) (candies : List Nat) 
  (h1 : n_friends > 0) (h2 : candies.length > 0) :
  (can_share_candies n_friends candies = "Yes" ∨ 
   can_share_candies n_friends candies = "No") := sorry

theorem can_share_candies_yes_iff_divisible (n_friends : Nat) (candies : List Nat)
  (h1 : n_friends > 0) (h2 : candies.length > 0) :
  can_share_candies n_friends candies = "Yes" ↔ 
  (List.sum candies % n_friends = 0) := sorry

theorem single_friend_always_yes (candies : List Nat) (h : candies.length > 0) :
  can_share_candies 1 candies = "Yes" := sorry

theorem zero_list_evenly_divisible (n_friends : Nat) (h : n_friends > 1) :
  can_share_candies n_friends [0] = "Yes" := sorry
