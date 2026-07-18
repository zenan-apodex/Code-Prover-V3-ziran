import Mathlib

structure Arrow where
  range : Int
  damaged : Option Bool

def any_arrows (arrows : List Arrow) : Bool := sorry

theorem any_arrows_all_damaged 
  (arrows : List Arrow)
  (h : ∀ a ∈ arrows, (a.damaged = some true)) :
  any_arrows arrows = false := sorry

theorem any_arrows_exists_undamaged
  (arrows : List Arrow)
  (h : ∃ a ∈ arrows, (a.damaged = some false) ∨ (a.damaged = none)) :
  any_arrows arrows = true := sorry

theorem any_arrows_empty :
  any_arrows [] = false := sorry

theorem any_arrows_undamaged_only
  (arrows : List Arrow)
  (h : ∀ a ∈ arrows, a.damaged = none) :
  any_arrows arrows = (arrows ≠ []) := sorry
