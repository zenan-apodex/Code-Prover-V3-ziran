import Mathlib

structure Edge where
  src : Int
  dst : Int
  weight : Int
deriving Repr

def shortest (n : Int) (edges : List Edge) : Int :=
  sorry

theorem shortest_basic_properties (n : Int) (edges : List Edge)
  (h1 : n ≥ 2) (h2 : n ≤ 10) (h3 : edges.length ≥ 1) (h4 : edges.length ≤ 20)
  (h5 : ∀ e ∈ edges, e.src ≥ 0 ∧ e.src < n ∧ 
                     e.dst ≥ 0 ∧ e.dst < n ∧ 
                     e.weight ≥ 1 ∧ e.weight ≤ 100 ∧
                     e.src ≠ e.dst) :
  let result := shortest n edges
  (result = -1 ∨ result > 0) ∧
  (∀ e ∈ edges, e.src = 0 ∧ e.dst = n-1 → result ≤ e.weight) :=
sorry

theorem shortest_empty_graph (n : Int)
  (h1 : n ≥ 2) (h2 : n ≤ 10) :
  shortest n [] = -1 :=
sorry

theorem shortest_single_direct_edge (n : Int) (w : Int)
  (h1 : n ≥ 2) (h2 : n ≤ 10) (h3 : w ≥ 1) (h4 : w ≤ 100) :
  shortest n [{ src := 0, dst := n-1, weight := w }] = w :=
sorry
