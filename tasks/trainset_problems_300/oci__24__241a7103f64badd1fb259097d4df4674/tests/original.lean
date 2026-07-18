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
inductive LevenshteinEdits : Nat → List Char → List Char → Prop where
  | nil : LevenshteinEdits 0 [] []
  | keep {n : Nat} {c : Char} {xs ys : List Char} :
      LevenshteinEdits n xs ys →
      LevenshteinEdits n (c :: xs) (c :: ys)
  | substitute {n : Nat} {c d : Char} {xs ys : List Char} :
      c ≠ d →
      LevenshteinEdits n xs ys →
      LevenshteinEdits (n + 1) (c :: xs) (d :: ys)
  | delete {n : Nat} {c : Char} {xs ys : List Char} :
      LevenshteinEdits n xs ys →
      LevenshteinEdits (n + 1) (c :: xs) ys
  | insert {n : Nat} {c : Char} {xs ys : List Char} :
      LevenshteinEdits n xs ys →
      LevenshteinEdits (n + 1) xs (c :: ys)
-- !benchmark @end postcond_aux


@[reducible, simp]
def LevenshteinDistance_postcond (s1 : String) (s2 : String) (result : Int)
    (h_precond : LevenshteinDistance_precond s1 s2) : Prop :=
  -- !benchmark @start postcond
  result ≥ 0 ∧
  LevenshteinEdits (Int.toNat result) s1.toList s2.toList ∧
  ∀ n : Nat, LevenshteinEdits n s1.toList s2.toList → Int.toNat result ≤ n
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem LevenshteinDistance_spec_satisfied (s1 : String) (s2 : String)
    (h_precond : LevenshteinDistance_precond s1 s2) :
    LevenshteinDistance_postcond s1 s2 (LevenshteinDistance s1 s2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof