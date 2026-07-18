-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
inductive TakeNonWhitespaceWord : List Char → List Char → List Char → Prop
| single_end (c : Char) (h : c.isWhitespace = false) :
    TakeNonWhitespaceWord [c] [c] []
| single_stop (c d : Char) (cs : List Char)
    (hc : c.isWhitespace = false) (hd : d.isWhitespace = true) :
    TakeNonWhitespaceWord (c :: d :: cs) [c] (d :: cs)
| cons (c d : Char) (cs w rest : List Char)
    (hc : c.isWhitespace = false) (hd : d.isWhitespace = false)
    (hrec : TakeNonWhitespaceWord (d :: cs) w rest) :
    TakeNonWhitespaceWord (c :: d :: cs) (c :: w) rest

inductive WhitespaceSeparatedWords : List Char → List (List Char) → Prop
| nil :
    WhitespaceSeparatedWords [] []
| skip (c : Char) (cs : List Char) (parts : List (List Char))
    (hc : c.isWhitespace = true)
    (hrest : WhitespaceSeparatedWords cs parts) :
    WhitespaceSeparatedWords (c :: cs) parts
| word (c : Char) (cs word rest : List Char) (parts : List (List Char))
    (hc : c.isWhitespace = false)
    (htake : TakeNonWhitespaceWord (c :: cs) word rest)
    (hrest : WhitespaceSeparatedWords rest parts) :
    WhitespaceSeparatedWords (c :: cs) (word :: parts)

def uppercaseWord (w : List Char) : String :=
  String.map Char.toUpper (String.mk w)
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def ModifyString_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def ModifyString (s : String) (h_precond : ModifyString_precond s) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def ModifyString_postcond (s : String) (result : String)
    (h_precond : ModifyString_precond s) : Prop :=
  -- !benchmark @start postcond
  ∃ parts : List (List Char),
    WhitespaceSeparatedWords s.toList parts ∧
    result = String.intercalate " " (parts.map uppercaseWord)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem ModifyString_spec_satisfied (s : String)
    (h_precond : ModifyString_precond s) :
    ModifyString_postcond s (ModifyString s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof