import Mathlib

def solve_periodic_sequence (n: Nat) (sequence: List Int) : String := sorry

def List.sum (l: List Int) : Int := sorry

theorem sum_zero (sequence: List Int) :
  solve_periodic_sequence 0 sequence = "0" := sorry

theorem cycle_repetition {n: Nat} {sequence: List Int} 
  (h: sequence.length > 0) :
  let cycled := List.join (List.replicate (n / sequence.length + 1) sequence)
  String.toInt! (solve_periodic_sequence n sequence) = 
    (List.take n cycled).sum := sorry

theorem cycle_consistency {n: Nat} {sequence: List Int}
  (h1: sequence.length > 0)
  (h2: n ≥ sequence.length) :
  String.toInt! (solve_periodic_sequence (n + sequence.length) sequence) - 
  String.toInt! (solve_periodic_sequence n sequence) = 
  sequence.sum := sorry
