import Mathlib

def maximum_sum_with_deletion (arr : List Int) : Int :=
  sorry

def list_maximum (arr : List Int) : Int :=
  sorry

def list_sum (arr : List Int) : Int :=
  sorry







theorem positive_scaling {arr : List Int} {scale : Int}
  (h : arr ≠ []) (hs : scale > 0) :
  maximum_sum_with_deletion (List.map (· * scale) arr) = 
  maximum_sum_with_deletion arr * scale :=
sorry
