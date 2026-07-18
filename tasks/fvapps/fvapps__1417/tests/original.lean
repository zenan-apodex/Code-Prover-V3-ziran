import Mathlib

def find_max_beauty (n: Nat) (tones: List Nat) : Nat := sorry

def countOccurrences (x : Nat) (xs : List Nat) : Nat :=
  xs.foldl (fun count y => if x = y then count + 1 else count) 0

def unique (xs : List Nat) : List Nat :=
  xs.foldl (fun acc x => if x ∈ acc then acc else x::acc) []

theorem find_max_beauty_is_min_frequency 
  (tones: List Nat) (h: ∀ x ∈ tones, 1 ≤ x ∧ x ≤ 8) :
  let distinct := unique tones;
  if distinct.length = 8 then
    find_max_beauty tones.length tones = 
      (List.map (fun x => countOccurrences x tones) distinct).minimum?
  else
    find_max_beauty tones.length tones = 0 := sorry

theorem find_max_beauty_non_negative 
  (tones: List Nat) (h: ∀ x ∈ tones, 1 ≤ x ∧ x ≤ 8) :
  find_max_beauty tones.length tones ≥ 0 := sorry
