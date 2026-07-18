import Mathlib

def find_longest_uncommon_subseq (strs : List String) : Int := sorry

theorem find_longest_uncommon_subseq_output_type_and_range
  (strs : List String)
  (h : strs.length > 0) :
  let result := find_longest_uncommon_subseq strs
  result = -1 ∨ result ≥ 0 := sorry

theorem find_longest_uncommon_subseq_bounded_by_max_length
  (strs : List String)
  (h : strs.length > 0) :
  find_longest_uncommon_subseq strs ≤ (strs.map String.length).maximum?.getD 0 := sorry



theorem find_longest_uncommon_subseq_single_string
  (s : String)
  (strs : List String)
  (h : strs = [s]) :
  find_longest_uncommon_subseq strs = s.length := sorry
