import Mathlib

def minimum : Nat → List Nat → Nat
| x, [] => x
| x, y::ys => if y <= x then minimum y ys else minimum x ys

theorem min_in_list : minimum x xs ∈ (x::xs) := by sorry
