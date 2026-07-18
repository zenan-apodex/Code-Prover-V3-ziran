import Mathlib

structure SegmentTree where
  lst : List Nat
  
def SegmentTree.query (tree : SegmentTree) (i j : Nat) : Nat :=
  sorry

def longest_apple_sequence (n : Nat) (s : List Bool) : Nat :=
  sorry

def list_max : List Nat → Nat 
| [] => 0
| [x] => x
| (x::xs) => max x (list_max xs)

theorem query_matches_slice_max {lst : List Nat} {tree : SegmentTree} 
  (h : tree.lst = lst) :
  ∀ i j, i < j → j ≤ lst.length →
  tree.query i j = list_max (List.drop i (List.take j lst)) :=
  sorry

theorem query_whole_list {lst : List Nat} {tree : SegmentTree}
  (h : tree.lst = lst) :
  tree.query 0 lst.length = list_max lst :=
  sorry

theorem query_single_element {lst : List Nat} {tree : SegmentTree}
  (h : tree.lst = lst) :
  ∀ (i : Nat) (h : i < lst.length),
  tree.query i (i+1) = lst[i]'h :=
  sorry

theorem longest_apple_sequence_non_negative 
  (n : Nat) (s : List Bool) :
  longest_apple_sequence n s ≥ 0 :=
  sorry

theorem all_zeros_gives_zero (n : Nat) (s : List Bool)
  (h : ∀ x ∈ s, x = false) :
  longest_apple_sequence n s = 0 :=
  sorry
