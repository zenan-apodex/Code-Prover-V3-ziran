import Mathlib

inductive ListNode where
  | mk : Nat → Option ListNode → ListNode
deriving Inhabited

def nextLargerNodes (head : Option ListNode) : List Nat :=
  sorry

theorem empty_list :
  nextLargerNodes none = [] ∧
  nextLargerNodes (some (ListNode.mk 0 none)) = [] :=
  sorry

theorem single_node (v : Nat) :
  nextLargerNodes (some (ListNode.mk v none)) = [0] :=
  sorry

theorem output_length_matches_input {vals : List Nat} {head : Option ListNode} :
  nextLargerNodes head = vals → List.length (nextLargerNodes head) = List.length vals :=
  sorry

theorem output_zero_or_greater {vals : List Nat} {head : Option ListNode} {i : Nat} :
  i < List.length vals →
  match (nextLargerNodes head).get? i with
  | some x => x = 0 ∨ x > vals.get! i
  | none => True
  :=
  sorry

theorem output_values_in_input {vals : List Nat} {head : Option ListNode} {x : Nat} :
  x ∈ nextLargerNodes head → x = 0 ∨ x ∈ vals :=
  sorry

theorem nonzero_has_larger_after {vals : List Nat} {head : Option ListNode} {i : Nat} :
  i < List.length vals →
  (nextLargerNodes head).get! i ≠ 0 →
  ∃ j, j > i ∧ j < List.length vals ∧ vals.get! j ≥ (nextLargerNodes head).get! i :=
  sorry

def isDecreasing (l : List Nat) : Prop :=
  ∀ i j, i < j → j < l.length → l.get! i ≥ l.get! j

theorem decreasing_list_gives_zeros {vals : List Nat} {head : Option ListNode} :
  List.length vals ≥ 2 →
  isDecreasing vals →
  nextLargerNodes head = List.replicate (List.length vals) 0 :=
  sorry
