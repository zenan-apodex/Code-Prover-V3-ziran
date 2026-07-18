-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def LevenshteinDistance_precond (s1 : String) (s2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def LevenshteinDistance (s1 : String) (s2 : String)
    (h_precond : LevenshteinDistance_precond s1 s2) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive LevenshteinRel : List Char → List Char → Nat → Prop where
  | nil :
      LevenshteinRel [] [] 0
  | insert {xs ys : List Char} {c : Char} {n : Nat} :
      LevenshteinRel xs ys n →
      LevenshteinRel xs (c :: ys) (n + 1)
  | delete {xs ys : List Char} {c : Char} {n : Nat} :
      LevenshteinRel xs ys n →
      LevenshteinRel (c :: xs) ys (n + 1)
  | keep {xs ys : List Char} {c : Char} {n : Nat} :
      LevenshteinRel xs ys n →
      LevenshteinRel (c :: xs) (c :: ys) n
  | substitute {xs ys : List Char} {c d : Char} {n : Nat} :
      c ≠ d →
      LevenshteinRel xs ys n →
      LevenshteinRel (c :: xs) (d :: ys) (n + 1)
-- !benchmark @end postcond_aux


@[reducible, simp]
def LevenshteinDistance_postcond (s1 : String) (s2 : String) (result : Int)
    (h_precond : LevenshteinDistance_precond s1 s2) : Prop :=
  -- !benchmark @start postcond
  ∃ n : Nat,
    result = n ∧
    LevenshteinRel s1.toList s2.toList n ∧
    ∀ m : Nat, LevenshteinRel s1.toList s2.toList m → n ≤ m
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem LevenshteinDistance_spec_satisfied (s1 : String) (s2 : String)
    (h_precond : LevenshteinDistance_precond s1 s2) :
    LevenshteinDistance_postcond s1 s2
      (LevenshteinDistance s1 s2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof