import Mathlib

def dominator (arr : List Int) : Int := sorry

theorem dominator_empty_list :
  dominator [] = -1 := sorry

theorem dominator_singleton (x : Int) :
  dominator [x] = x := sorry

theorem dominator_majority {base : List Int} {dom_value : Int} {repeats : Nat}
  (h_repeats : repeats > base.length) :
  dominator (base ++ List.replicate repeats dom_value) = dom_value := sorry
