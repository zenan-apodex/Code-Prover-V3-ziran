import Mathlib

def est_subsets {α : Type} [BEq α] [Hashable α] (arr : List α) : Nat :=
  sorry

def list_unique_count {α : Type} [BEq α] [Hashable α] (arr : List α) : Nat :=
  sorry

theorem est_subsets_count_prop {α : Type} [BEq α] [Hashable α] (arr : List α) :
  est_subsets arr = 2^(list_unique_count arr) - 1 :=
  sorry

theorem est_subsets_nonneg {α : Type} [BEq α] [Hashable α] (arr : List α) :
  est_subsets arr ≥ 0 :=
  sorry

theorem est_subsets_empty {α : Type} [BEq α] [Hashable α] :
  est_subsets ([] : List α) = 0 :=
  sorry

theorem est_subsets_duplicates {α : Type} [BEq α] [Hashable α] (arr : List α) :
  est_subsets arr = est_subsets (arr ++ arr) :=
  sorry

theorem est_subsets_is_nat {α : Type} [BEq α] [Hashable α] (arr : List α) :
  est_subsets arr = 2^(list_unique_count arr) - 1 :=
  sorry
