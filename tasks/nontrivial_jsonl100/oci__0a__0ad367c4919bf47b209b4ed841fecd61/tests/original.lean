-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def Permute_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def Permute (s : String) (h_precond : Permute_precond s) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def isPermutation' (s1 s2 : String) : Prop :=
  s1.toList.Perm s2.toList

def allPermsOf' (perms : List String) (s : String) : Prop :=
  ∀ p ∈ perms, isPermutation' p s

def containsAllPerms' (perms : List String) (s : String) : Prop :=
  ∀ cs : List Char, cs.Perm s.toList → String.mk cs ∈ perms

def lexLE' (s1 s2 : String) : Prop :=
  s1.toList ≤ s2.toList

def isSortedLex' (xs : List String) : Prop :=
  List.Pairwise (fun a b => lexLE' a b) xs
-- !benchmark @end postcond_aux


@[reducible, simp]
def Permute_postcond (s : String) (result : List String) (h_precond : Permute_precond s) : Prop :=
  -- !benchmark @start postcond
  -- Every element in result is a permutation of s
  allPermsOf' result s ∧
  -- Every permutation of s appears in result
  containsAllPerms' result s ∧
  -- The result has exactly n! elements (counting duplicates from repeated chars)
  result.length = Nat.factorial s.toList.length ∧
  -- The result is sorted lexicographically
  isSortedLex' result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem Permute_spec_satisfied (s : String) (h_precond : Permute_precond s) :
    Permute_postcond s (Permute s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof