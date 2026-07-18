import Mathlib

inductive Input 
  | number (n : Int)
  | text (s : String)
  | binary (b : ByteArray)
  | list (l : List Int)
  | none

def my_add : Input → Input → Option Input := sorry

theorem add_numbers (a b : Int) :
  my_add (Input.number a) (Input.number b) = some (Input.number (a + b)) := sorry

theorem add_number_and_string (a : Int) (b : String) :
  my_add (Input.number a) (Input.text b) = none := sorry

theorem add_non_numbers {a b : Input} 
  (h1 : ¬∃ n : Int, a = Input.number n) 
  (h2 : ¬∃ n : Int, b = Input.number n) :
  my_add a b = none ∨ 
  (∃ s : String, my_add a b = some (Input.text s)) ∨
  (∃ bs : ByteArray, my_add a b = some (Input.binary bs)) ∨
  (∃ l : List Int, my_add a b = some (Input.list l)) := sorry

theorem add_none_left (x : Input) :
  my_add Input.none x = none := sorry

theorem add_none_right (x : Input) :
  my_add x Input.none = none := sorry

theorem add_none_both :
  my_add Input.none Input.none = none := sorry
