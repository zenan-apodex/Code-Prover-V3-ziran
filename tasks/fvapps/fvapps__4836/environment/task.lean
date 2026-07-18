import Mathlib

def DateTime := Nat -- simplified representation
def TimeDelta := Nat -- simplified representation

instance : Add DateTime where
  add := Nat.add

instance : HAdd DateTime TimeDelta DateTime where
  hAdd := Nat.add

def elapsedSeconds (s e : DateTime) : Nat :=
  sorry

theorem elapsedSeconds_nonnegative
  (s : DateTime)
  (e : DateTime)
  (d : TimeDelta)
  (h : e = s + d) :
  elapsedSeconds s e ≥ 0 :=
  sorry

theorem elapsedSeconds_matches_delta
  (s : DateTime)
  (e : DateTime) 
  (d : TimeDelta)
  (h : e = s + d) :
  elapsedSeconds s e = d :=
  sorry

theorem elapsedSeconds_identity
  (dt : DateTime) :
  elapsedSeconds dt dt = 0 :=
  sorry
