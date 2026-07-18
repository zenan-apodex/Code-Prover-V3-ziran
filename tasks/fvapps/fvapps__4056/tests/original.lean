import Mathlib

def leaderboard_sort (names : List String) (changes : List String) : List String :=
  sorry

def parseChange (change : String) : String × Int :=
  sorry

theorem leaderboard_invariants
  (names : List String)
  (changes : List String)
  (h_names : names.length > 0)
  (h_unique : ∀ x y, x ∈ names → y ∈ names → x = y → names.indexOf x = names.indexOf y) :
  let result := leaderboard_sort names changes
  -- Length preserved
  (result.length = names.length) ∧
  -- All elements preserved
  (∀ x, x ∈ names ↔ x ∈ result) ∧
  -- Valid movements
  (∀ change ∈ changes,
    let (name, delta) := parseChange change
    name ∈ names →
    names.indexOf name - result.indexOf name = delta) :=
  sorry

theorem leaderboard_bounds
  (names : List String)
  (changes : List String)
  (h : changes.length = 1) :
  let result := leaderboard_sort names changes
  let (name, delta) := parseChange changes.head!
  -- Result maintains bounds
  (result.indexOf name ≥ 0) ∧
  (result.indexOf name < names.length) :=
  sorry
