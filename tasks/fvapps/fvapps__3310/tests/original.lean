import Mathlib

structure Vaulter where
  name : String 
  results : List String
  deriving Repr

def score_pole_vault (vaulters : List Vaulter) : List (String × String) :=
  sorry

-- Properties about valid placements
theorem score_pole_vault_valid_places (vaulters : List Vaulter) :
  let result := score_pole_vault vaulters
  ∀ p ∈ result, p.1 ∈ ["1st", "2nd", "3rd"] :=
sorry

theorem score_pole_vault_max_places (vaulters : List Vaulter) :
  let result := score_pole_vault vaulters
  result.length ≤ 3 :=
sorry

-- Properties about tie/jump-off formatting
theorem score_pole_vault_tie_format (vaulters : List Vaulter) :
  let result := score_pole_vault vaulters
  ∀ p ∈ result,
    p.2.contains '(' → (p.2.splitOn ",").length > 1 :=
sorry

theorem score_pole_vault_jumpoff_format (vaulters : List Vaulter) :
  let result := score_pole_vault vaulters
  ∀ p ∈ result,
    p.2.contains 'j' →
      (p.2.splitOn ",").length > 1 ∧ p.1 = "1st" :=
sorry

-- Property about names in result appearing in original vaulters 
theorem score_pole_vault_valid_names (vaulters : List Vaulter) :
  let result := score_pole_vault vaulters
  let processName (s : String) := s.trim
  ∀ p ∈ result, ∀ name ∈ p.2.splitOn ",",
    ∃ v ∈ vaulters, v.name = processName name :=
sorry

-- Property about ordering of places
theorem score_pole_vault_ordered_places (vaulters : List Vaulter) :
  let result := score_pole_vault vaulters
  result.length > 1 →
    ∀ i j, i < j → j < result.length →
      (result[i]!.1.front.toNat) ≤ (result[j]!.1.front.toNat) :=
sorry
