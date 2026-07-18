import Mathlib

def find_replace_string (s: String) (indexes: List Nat) (sources targets: List String) : String :=
  sorry

theorem output_is_string {s: String} {indexes: List Nat} {sources targets: List String}:
  find_replace_string s indexes sources targets = (find_replace_string s indexes sources targets) := by
  sorry

theorem unchanged_on_non_matches {s: String} {indexes: List Nat} {sources targets: List String}:
  ∀ (i: Nat) (src tgt: String),
  (i ∈ indexes) →
  (sources.getD (indexes.indexOf i) "" = src) → 
  (targets.getD (indexes.indexOf i) "" = tgt) →
  (i < s.length) →
  (String.take (String.drop s i) src.length ≠ src) →
  (find_replace_string s indexes sources targets).all (fun c => ¬tgt.contains c) := by
  sorry
