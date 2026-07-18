import Mathlib

structure Version where
  nums : List Nat

def splitVersion (v : String) : Version := sorry
def joinVersion (v : Version) : String := sorry
def nextVersion (v : String) : String := sorry

theorem nextVersion_outputs_valid_version (v : String) 
    (h : ∀ n ∈ (splitVersion v).nums, n ≤ 8) :
  ∀ n ∈ (splitVersion (nextVersion v)).nums, n ≥ 0 := sorry

theorem nextVersion_preserves_length (v : String)
    (h : ∀ n ∈ (splitVersion v).nums, n ≤ 8) :
  (splitVersion (nextVersion v)).nums.length = (splitVersion v).nums.length := sorry

theorem nextVersion_preserves_prefix_parts (v : String)
    (h : ∀ n ∈ (splitVersion v).nums, n ≤ 8)
    (h2 : (splitVersion v).nums ≠ [])
    (h3 : ((splitVersion v).nums.getLast h2) < 9) : 
  (splitVersion (nextVersion v)).nums.dropLast = (splitVersion v).nums.dropLast ∧ 
  ((splitVersion (nextVersion v)).nums.getLast h2 = (splitVersion v).nums.getLast h2 + 1) := sorry
