import Mathlib

universe u

inductive NestedList (α : Type u)
  | atom : α → NestedList α
  | list : List (NestedList α) → NestedList α

def sumNestedNumbers : NestedList Int → Int := sorry

def List.sum : List Int → Int 
  | [] => 0
  | x :: xs => x + List.sum xs

theorem flat_list_sum (lst : List Int) : 
  sumNestedNumbers (NestedList.list (lst.map NestedList.atom)) = lst.sum := sorry

theorem single_element (x : Int) : 
  sumNestedNumbers (NestedList.list [NestedList.atom x]) = x := sorry

theorem single_nested_element (x : Int) :
  sumNestedNumbers (NestedList.list [NestedList.list [NestedList.atom x]]) = x * x := sorry

theorem double_nested_element (x : Int) :
  sumNestedNumbers (NestedList.list [NestedList.list [NestedList.list [NestedList.atom x]]]) = 
    x * x * x := sorry
