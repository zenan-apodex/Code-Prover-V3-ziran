import Mathlib

inductive ListNode where
  | nil : ListNode
  | cons : Int → ListNode → ListNode
deriving Repr

def arrayToLinkedList : List Int → ListNode := sorry
def linkedListToArray : ListNode → List Int := sorry 
def sortList : ListNode → ListNode := sorry

def isSorted : List Int → Bool
  | [] => true
  | [_] => true
  | x :: y :: rest => x ≤ y && isSorted (y :: rest)

theorem sort_maintains_elements (arr : List Int) :
  ∃ perm : List Int, linkedListToArray (sortList (arrayToLinkedList arr)) = perm := sorry

theorem sorted_result (arr : List Int) :
  let result := linkedListToArray (sortList (arrayToLinkedList arr))
  isSorted result := sorry

theorem length_preserved (arr : List Int) :
  (linkedListToArray (sortList (arrayToLinkedList arr))).length = arr.length := sorry

theorem max_min_preserved (arr : List Int) (h : arr ≠ []) :
  let result := linkedListToArray (sortList (arrayToLinkedList arr))
  let min := result[0]!
  let max := result[result.length - 1]!
  (∀ x ∈ arr, min ≤ x) ∧ (∀ x ∈ arr, x ≤ max) := sorry

theorem empty_list :
  sortList ListNode.nil = ListNode.nil := sorry
