-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def GeneratePermutations_precond (s : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def GeneratePermutations (s : String) (h_precond : GeneratePermutations_precond s) : List String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def IsIndexPermutation (n : Nat) (ps : List Nat) : Prop :=
  ps.length = n ∧ ∀ i : Nat, i < n ↔ i ∈ ps

def StringFromIndices (chars : List Char) (ps : List Nat) : String :=
  String.mk (ps.map (fun i => chars[i]!))
-- !benchmark @end postcond_aux


@[reducible, simp]
def GeneratePermutations_postcond (s : String) (result : List String) (h_precond : GeneratePermutations_precond s) : Prop :=
  -- !benchmark @start postcond
  let chars := s.toList
  ∃ idxPerms : List (List Nat),
    idxPerms.length = result.length ∧
    List.Pairwise (fun a b => a ≠ b) idxPerms ∧
    (∀ ps ∈ idxPerms, IsIndexPermutation chars.length ps) ∧
    (∀ ps : List Nat, IsIndexPermutation chars.length ps → ps ∈ idxPerms) ∧
    (∀ k : Nat, k < result.length →
      (result[k]!).toList = (StringFromIndices chars (idxPerms[k]!)).toList)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem GeneratePermutations_spec_satisfied (s : String) (h_precond : GeneratePermutations_precond s) :
    GeneratePermutations_postcond s (GeneratePermutations s h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof