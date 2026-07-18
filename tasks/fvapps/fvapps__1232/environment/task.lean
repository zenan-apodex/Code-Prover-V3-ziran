import Mathlib

structure Node where
  nodeType : Nat
  inputA : Nat
  inputB : Nat
deriving Repr

def parseNode (spec : Nat ⊕ (Nat × Nat × Nat)) : Node :=
  match spec with
  | Sum.inl n => { nodeType := n, inputA := 0, inputB := 0 }
  | Sum.inr (t, a, b) => { nodeType := t, inputA := a, inputB := b }

def calcOutputProb (nodes : List Node) (p : Float) : Float :=
  sorry

def findPForHalf (nodes : List Node) : Float :=
  sorry

theorem input_only_nodes_half_prob (nodes : List Node)
  (h : ∀ n ∈ nodes, n.nodeType = 0) :
  Float.abs (findPForHalf nodes - 0.5) < 0.00001 := sorry

theorem output_prob_bounded (nodes : List Node) (p : Float)
  (h1 : 0 ≤ p ∧ p ≤ 1) : 
  let out := calcOutputProb nodes p
  0 ≤ out ∧ out ≤ 1 := sorry
