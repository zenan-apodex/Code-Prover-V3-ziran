import Mathlib

theorem prop_append_inj_1 (xs ys zs: List α) [DecidableEq α] :
  (xs ++ zs == ys ++ zs) → xs == ys:= by sorry
