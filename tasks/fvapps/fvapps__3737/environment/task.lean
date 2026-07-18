import Mathlib

variable (operation : List Int → Int)

axiom operation_empty : operation [] = 0

theorem operation_type_nonempty {sequence : List Int} (h : sequence ≠ []) :
  ∃ (result : Int), operation sequence = result :=
  sorry

theorem operation_empty_case :
  operation [] = 0 :=
  operation_empty operation

theorem operation_type_bounded_length {sequence : List Int} (h : sequence.length ≤ 100) :
  ∃ (result : Int), operation sequence = result :=
  sorry

theorem operation_type_repeated (x : Int) (length : Nat) (h : 0 < length ∧ length ≤ 10) :
  ∃ (result : Int), operation (List.replicate length x) = result :=
  sorry

theorem operation_type_alternating_signs {sequence : List Int} (h : sequence ≠ []) :
  ∃ (result : Int), operation sequence = result :=
  sorry

theorem operation_type_small_ints {sequence : List Int}
    (h1 : sequence ≠ [])
    (h2 : sequence.length ≤ 10)
    (h3 : ∀ x ∈ sequence, -100 ≤ x ∧ x ≤ 100) :
  ∃ (result : Int), operation sequence = result :=
  sorry
