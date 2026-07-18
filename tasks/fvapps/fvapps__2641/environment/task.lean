import Mathlib

structure DateTime where
  year : Nat
  month : Nat  
  day : Nat
  hour : Nat
  minute : Nat
  second : Nat
  timezone : Int
deriving Repr

def parseDateTime (s : String) : DateTime := sorry

def absTimeDiffInSeconds (t1 t2 : DateTime) : Nat := sorry

def timeDifference (ts1 ts2 : String) : Nat := sorry

theorem timeDiff_nonneg (ts1 ts2 : String) :
  timeDifference ts1 ts2 ≥ 0 := sorry

theorem timeDiff_commutative (ts1 ts2 : String) :
  timeDifference ts1 ts2 = timeDifference ts2 ts1 := sorry

theorem timeDiff_matches_datetime (ts1 ts2 : String) :
  let dt1 := parseDateTime ts1
  let dt2 := parseDateTime ts2
  timeDifference ts1 ts2 = absTimeDiffInSeconds dt1 dt2 := sorry

theorem timeDiff_same_timestamp (ts : String) :
  timeDifference ts ts = 0 := sorry
