import Mathlib

structure Transaction where
  name : String
  time : Int 
  amount : Int
  city : String
  deriving Repr

def Transaction.array (t : Transaction) : String := sorry

def find_invalid_transactions (trans : List String) : List String := sorry

def abs (n : Int) : Int := 
  if n < 0 then -n else n







def splitStr (s : String) : List String := sorry



theorem transaction_construction (name : String) (time amount : Int) (city : String) :
  let t := Transaction.mk name time amount city
  t.name = name ∧ 
  t.time = time ∧
  t.amount = amount ∧ 
  t.city = city := sorry
