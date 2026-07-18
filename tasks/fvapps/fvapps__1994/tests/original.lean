import Mathlib

/- Basic structure for linked list -/
inductive ListNode where
  | nil : ListNode
  | cons : Int → ListNode → ListNode
deriving Repr

def create_linked_list (values : List Int) : ListNode := sorry

def numComponents (head : ListNode) (values : List Int) : Nat := sorry

theorem full_list_is_one_component (values : List Int) (h : values ≠ []) :
  numComponents (create_linked_list values) values = 1 := sorry

theorem disjoint_lists_return_zero {values g : List Int} (h1 : values ≠ [])
  (h2 : ∀ x, x ∈ values → x ∉ g) :
  numComponents (create_linked_list values) g = 0 := sorry

theorem single_value_gives_one_component {values : List Int} (h1 : values ≠ [])
  (h2 : ∀ x y, x ∈ values → y ∈ values → x ≠ y) :  
  numComponents (create_linked_list values) [values.head!] = 1 := sorry
