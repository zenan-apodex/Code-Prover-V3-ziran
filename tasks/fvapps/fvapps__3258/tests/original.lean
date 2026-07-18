import Mathlib

def transpose (amount : Int) (tab : List String) : List String := sorry

def Nat.toString (n : Nat) : String := sorry

theorem transpose_basic_format 
  (tab : List String)
  (amount : Int)
  (h1 : -5 ≤ amount)
  (h2 : amount ≤ 5) :
  let result := transpose amount tab
  if result ≠ ["Out of frets!"] then
    (∀ r ∈ result, 
      r.length > 0 ∧ 
      ((r.data.get? 0).isSome ∧
       ((r.data.get? 0).getD '_' = 'e' ∨ 
        (r.data.get? 0).getD '_' = 'E' ∨
        (r.data.get? 0).getD '_' = 'B' ∨
        (r.data.get? 0).getD '_' = 'G' ∨
        (r.data.get? 0).getD '_' = 'D' ∨
        (r.data.get? 0).getD '_' = 'A')) ∧
      (r.data.get? 1).isSome ∧
      (r.data.get? 1).getD '_' = '|') ∧
    result.length = 6 ∧
    (∀ line ∈ result,
      ∀ n : Nat,
      (n ≥ 0 ∧ n ≤ 22))
  else True :=
sorry
