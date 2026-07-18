-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
inductive RomanThousands : List Char → Int → Prop
| nil : RomanThousands [] 0
| m : RomanThousands ['M'] 1000
| mm : RomanThousands ['M', 'M'] 2000
| mmm : RomanThousands ['M', 'M', 'M'] 3000

inductive RomanHundreds : List Char → Int → Prop
| nil : RomanHundreds [] 0
| c : RomanHundreds ['C'] 100
| cc : RomanHundreds ['C', 'C'] 200
| ccc : RomanHundreds ['C', 'C', 'C'] 300
| cd : RomanHundreds ['C', 'D'] 400
| d : RomanHundreds ['D'] 500
| dc : RomanHundreds ['D', 'C'] 600
| dcc : RomanHundreds ['D', 'C', 'C'] 700
| dccc : RomanHundreds ['D', 'C', 'C', 'C'] 800
| cm : RomanHundreds ['C', 'M'] 900

inductive RomanTens : List Char → Int → Prop
| nil : RomanTens [] 0
| x : RomanTens ['X'] 10
| xx : RomanTens ['X', 'X'] 20
| xxx : RomanTens ['X', 'X', 'X'] 30
| xl : RomanTens ['X', 'L'] 40
| l : RomanTens ['L'] 50
| lx : RomanTens ['L', 'X'] 60
| lxx : RomanTens ['L', 'X', 'X'] 70
| lxxx : RomanTens ['L', 'X', 'X', 'X'] 80
| xc : RomanTens ['X', 'C'] 90

inductive RomanOnes : List Char → Int → Prop
| nil : RomanOnes [] 0
| i : RomanOnes ['I'] 1
| ii : RomanOnes ['I', 'I'] 2
| iii : RomanOnes ['I', 'I', 'I'] 3
| iv : RomanOnes ['I', 'V'] 4
| v : RomanOnes ['V'] 5
| vi : RomanOnes ['V', 'I'] 6
| vii : RomanOnes ['V', 'I', 'I'] 7
| viii : RomanOnes ['V', 'I', 'I', 'I'] 8
| ix : RomanOnes ['I', 'X'] 9

def RomanNumeralValue (cs : List Char) (n : Int) : Prop :=
  ∃ th hu te on a b c d,
    RomanThousands th a ∧
    RomanHundreds hu b ∧
    RomanTens te c ∧
    RomanOnes on d ∧
    cs = th ++ hu ++ te ++ on ∧
    n = a + b + c + d
-- !benchmark @end precond_aux

@[reducible, simp]
def RomanToInteger_precond (s : String) : Prop :=
  -- !benchmark @start precond
  s.length > 0 ∧ s.length ≤ 15 ∧ ∃ n : Int, RomanNumeralValue s.toList n
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def RomanToInteger (s : String) (h_precond : RomanToInteger_precond s) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux


@[reducible, simp]
def RomanToInteger_postcond (s : String) (result : Int) (h_precond : RomanToInteger_precond s) : Prop :=
  -- !benchmark @start postcond
  RomanNumeralValue s.toList result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem RomanToInteger_spec_satisfied (s : String) (h_precond : RomanToInteger_precond s) :
    RomanToInteger_postcond s (RomanToInteger s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof