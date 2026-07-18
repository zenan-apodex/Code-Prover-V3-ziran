import Mathlib

universe u

inductive Item where
  | Int : Int → Item
  | Str : String → Item
deriving Repr

def List.sum (l : List Int) : Int := 
  l.foldl (· + ·) 0

def div_con (lst : List Item) : Int := sorry

def string_is_numeric (s : String) : Bool := sorry

def string_to_int (s : String) : Int := sorry

theorem div_con_main_property (lst : List Item)
  (h : ∀ s, s ∈ lst → match s with | Item.Str s => string_is_numeric s | _ => true) :
  div_con lst = 
    (lst.filterMap (fun x => match x with
      | Item.Int n => some n
      | _ => none)).sum -
    (lst.filterMap (fun x => match x with
      | Item.Str s => if string_is_numeric s then some (string_to_int s) else none
      | _ => none)).sum := sorry

theorem div_con_all_ints (lst : List Int) :
  div_con (lst.map Item.Int) = lst.sum := sorry

theorem div_con_all_strings (lst : List String)
  (h : ∀ s, s ∈ lst → string_is_numeric s) :
  div_con (lst.map Item.Str) = -(lst.map string_to_int).sum := sorry
