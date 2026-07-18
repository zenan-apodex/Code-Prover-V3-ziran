import Mathlib

-- <vc-preamble>
-- </vc-preamble>

-- <vc-helpers>
-- </vc-helpers>

-- <vc-definitions>
def lcs (x y : String) : String := sorry

def isSubsequence (s t : String) : Bool := sorry
-- </vc-definitions>

-- <vc-theorems>
theorem lcs_empty_string 
  (x y : String) :
  lcs "" y = "" ∧ lcs x "" = "" := sorry
-- </vc-theorems>
