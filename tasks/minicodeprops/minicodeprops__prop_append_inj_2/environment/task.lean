import Mathlib

theorem prop_append_inj_2 (xs ys zs: List α) [DecidableEq α] :
  (xs ++ ys == xs ++ zs) → ys == zs:= by sorry
