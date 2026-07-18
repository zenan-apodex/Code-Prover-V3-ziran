-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def GetPermutation_precond (n : Int) (k : Int) : Prop :=
  -- !benchmark @start precond
  1 ≤ n ∧ n ≤ 9 ∧ 1 ≤ k ∧ k ≤ Nat.factorial n.toNat
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def GetPermutation (n : Int) (k : Int) (h_precond : GetPermutation_precond n k) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- Convert a list of digits to an integer, e.g. [2,3,1,4] -> 2314 -/
def digitsToInt : List Nat → Int
  | [] => 0
  | d :: ds => d * (10 ^ ds.length : Nat) + digitsToInt ds

/-- Check if a list is a permutation of [1, ..., n] -/
def isPermOfRange (xs : List Nat) (n : Nat) : Prop :=
  xs.length = n ∧ (∀ i, 1 ≤ i ∧ i ≤ n → i ∈ xs) ∧ xs.Nodup

/-- All permutations of [1..n] sorted lexicographically -/
noncomputable def allPermsLex (n : Nat) : List (List Nat) :=
  let base := (List.range n).map (· + 1)
  base.permutations.filter (fun p => p.length = n)
    |>.mergeSort (fun a b => a ≤ b)

/-- Lexicographic comparison on lists of Nat -/
def lexLt : List Nat → List Nat → Prop
  | [], _ :: _ => True
  | [], [] => False
  | _ :: _, [] => False
  | a :: as, b :: bs => a < b ∨ (a = b ∧ lexLt as bs)

/-- Lexicographic ≤ on lists of Nat -/
def lexLe (a b : List Nat) : Prop :=
  lexLt a b ∨ a = b
-- !benchmark @end postcond_aux


@[reducible, simp]
def GetPermutation_postcond (n : Int) (k : Int) (result : Int) (h_precond : GetPermutation_precond n k) : Prop :=
  -- !benchmark @start postcond
  -- There exists a list of digits that:
  ∃ (digits : List Nat),
    -- converts to the result integer
    digitsToInt digits = result ∧
    -- is a permutation of [1..n]
    isPermOfRange digits n.toNat ∧
    -- has exactly (k-1) permutations of [1..n] that are lexicographically smaller
    (let allPerms := {p : List Nat | isPermOfRange p n.toNat ∧ lexLt p digits}
     -- The number of permutations strictly less than digits is exactly k-1
     -- We express this by: digits is the k-th smallest among all permutations of [1..n]
     -- i.e., there are exactly (k.toNat - 1) permutations that are lexicographically smaller
     ∃ (smaller : List (List Nat)),
       smaller.length = k.toNat - 1 ∧
       smaller.Nodup ∧
       (∀ p ∈ smaller, isPermOfRange p n.toNat ∧ lexLt p digits) ∧
       (∀ p, isPermOfRange p n.toNat → lexLt p digits → p ∈ smaller))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem GetPermutation_spec_satisfied (n : Int) (k : Int) (h_precond : GetPermutation_precond n k) :
    GetPermutation_postcond n k (GetPermutation n k h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof