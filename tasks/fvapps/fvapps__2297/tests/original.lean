import Mathlib

structure DSU (n : Nat) where
  parent_or_size : Array Int

def DSU.merge (dsu : DSU n) (a b : Nat) : Nat := sorry
def DSU.leader (dsu : DSU n) (a : Nat) : Nat := sorry
def solve_game (n m : Nat) (required gain : Array Int) (edges : Array (Nat × Nat)) : Int := sorry





theorem single_node_property (n : Nat) :
  n > 0 →
  solve_game 1 0 #[n] #[0] #[] = n := sorry
