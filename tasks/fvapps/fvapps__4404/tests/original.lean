import Mathlib

namespace VersionCompare

def compare (v1 v2 : String) : Int := sorry

@[simp] theorem compare_symmetry {v1 v2 : String} :
  VersionCompare.compare v1 v2 = -(VersionCompare.compare v2 v1) := sorry

@[simp] theorem compare_identity {v : String} :
  VersionCompare.compare v v = 0 := sorry

theorem trailing_zeros_ignored {v : String} :
  VersionCompare.compare v (v ++ ".0") = 0 ∧ 
  VersionCompare.compare v (v ++ ".0.0") = 0 := sorry

theorem compare_transitivity {v1 v2 v3 : String} :
  VersionCompare.compare v1 v2 ≥ 0 → 
  VersionCompare.compare v2 v3 ≥ 0 → 
  VersionCompare.compare v1 v3 ≥ 0 := sorry

theorem compare_returns_valid {v1 v2 : String} :
  VersionCompare.compare v1 v2 = -1 ∨ 
  VersionCompare.compare v1 v2 = 0 ∨ 
  VersionCompare.compare v1 v2 = 1 := sorry

end VersionCompare
