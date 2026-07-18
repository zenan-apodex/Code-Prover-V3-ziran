import Mathlib

/-- Function that calculates share price given investment and list of percentage changes -/
def share_price (invested : Float) (changes : List Float) : String :=
  sorry

def parseFloat? (s : String) : Option Float :=
  sorry

theorem share_price_valid_format {invested : Float} {changes : List Float}
  (h1 : invested > 0)
  (h2 : ∀ c ∈ changes, c ≥ -99.99 ∧ c ≤ 1000) :
  ∃ p d, 
    share_price invested changes = p ++ "." ++ d ∧  
    d.length = 2 ∧
    (parseFloat? (share_price invested changes)).isSome ∧ 
    ∃ x, parseFloat? (share_price invested changes) = some x ∧ x ≥ 0 := sorry

theorem share_price_empty_changes {invested : Float}
  (h : invested > 0) :
  share_price invested [] = toString invested ++ "." ++ "00" := sorry
