import Mathlib

def Funnel := List (List Char)

def funnel_out (f : Funnel) : List Char := sorry

theorem funnel_structure_preserved (f : Funnel) :
  let f' := f
  f = f' := sorry

theorem all_letters_output (f : Funnel) :
  let input_letters := f.join
  List.length (funnel_out f) = List.length input_letters := sorry

theorem funnel_fills_bottom (f : Funnel) :
  let total_letters := f.join.length 
  (funnel_out f).length = total_letters := sorry

theorem simple_cases :
  funnel_out [['a']] = ['a'] ∧  
  funnel_out [['a', 'b'], ['c']] = ['c', 'a', 'b'] := sorry
