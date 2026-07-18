import Mathlib

def catch_sign_change (lst : List Int) : Nat :=
  sorry

theorem empty_or_singleton_lists (lst : List Int) :
  lst.length ≤ 1 → catch_sign_change lst = 0 :=
  sorry





theorem count_is_nonnegative (lst : List Int) :
  catch_sign_change lst ≥ 0 :=
  sorry

theorem count_is_bounded (lst : List Int) :
  lst.length ≥ 2 → catch_sign_change lst ≤ lst.length - 1 :=
  sorry

theorem reversing_list_same_count (lst : List Int) :
  catch_sign_change lst = catch_sign_change lst.reverse :=
  sorry
