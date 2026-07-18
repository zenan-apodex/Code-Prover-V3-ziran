import Mathlib

inductive Dir where
  | U
  | D
  | L
  | R
  deriving Repr, Inhabited, BEq

structure Asteroid where
  x: Int 
  y: Int
  dir: Dir
  deriving Repr, BEq

def find_earliest_collision (earth_x earth_y: Int) (earth_dir: Dir) (asteroids: List Asteroid) : 
  String ⊕ Float := sorry

theorem find_earliest_collision_safe_or_bounded
  {earth_x earth_y: Int}
  {earth_dir: Dir}
  {asteroids: List Asteroid}
  (h1: earth_x ≥ -100 ∧ earth_x ≤ 100)
  (h2: earth_y ≥ -100 ∧ earth_y ≤ 100)
  (h3: asteroids.length ≤ 5)
  (h4: ∀ a ∈ asteroids, a.x ≥ -100 ∧ a.x ≤ 100 ∧ a.y ≥ -100 ∧ a.y ≤ 100) :
  let result := find_earliest_collision earth_x earth_y earth_dir asteroids
  match result with
  | Sum.inl s => s = "SAFE" 
  | Sum.inr f => f ≥ 0 ∧ f ≤ 1000000
  := sorry

theorem empty_asteroids_is_safe
  {earth_x earth_y: Int}
  {earth_dir: Dir}
  (h1: earth_x ≥ -100 ∧ earth_x ≤ 100)
  (h2: earth_y ≥ -100 ∧ earth_y ≤ 100) :
  find_earliest_collision earth_x earth_y earth_dir [] = Sum.inl "SAFE" := sorry

theorem same_direction_is_safe
  {asteroids: List Asteroid}
  {dir: Dir}
  (h: asteroids.length ≤ 5)
  (h2: ∀ a ∈ asteroids, a.x ≥ -100 ∧ a.x ≤ 100 ∧ a.y ≥ -100 ∧ a.y ≤ 100) :
  find_earliest_collision 0 0 dir (asteroids.map fun a => {x := a.x, y := a.y, dir := dir}) = 
    Sum.inl "SAFE" := sorry
