-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux

@[reducible, simp]
def LongestCommonSubsequence_precond (str1 : String) (str2 : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def LongestCommonSubsequence (str1 : String) (str2 : String) (h_precond : LongestCommonSubsequence_precond str1 str2) : Int :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
/-- `IsSubseq xs ys` means `xs` is a subsequence of `ys`. -/
def IsSubseq : List Char → List Char → Prop
  | [], _ => True
  | _ :: _, [] => False
  | x :: xs, y :: ys =>
    if x = y then IsSubseq xs ys
    else IsSubseq (x :: xs) ys

instance : DecidablePred (fun p : List Char × List Char => IsSubseq p.1 p.2) := by
  intro ⟨xs, ys⟩
  revert ys
  induction xs with
  | nil => intro ys; simp [IsSubseq]; exact isTrue trivial
  | cons x xs ih =>
    intro ys
    induction ys with
    | nil => simp [IsSubseq]; exact isFalse id
    | cons y ys ihy =>
      simp only [IsSubseq]
      split
      · exact ih ys
      · exact ihy

/-- A common subsequence of two lists -/
def IsCommonSubseq (cs l1 l2 : List Char) : Prop :=
  IsSubseq cs l1 ∧ IsSubseq cs l2
-- !benchmark @end postcond_aux


@[reducible, simp]
def LongestCommonSubsequence_postcond (str1 : String) (str2 : String) (result : Int) (h_precond : LongestCommonSubsequence_precond str1 str2) : Prop :=
  -- !benchmark @start postcond
  let l1 := str1.toList
  let l2 := str2.toList
  result ≥ 0 ∧
  -- There exists a common subsequence of this length
  (∃ cs : List Char, IsCommonSubseq cs l1 l2 ∧ cs.length = result.toNat) ∧
  -- No common subsequence is longer
  (∀ cs : List Char, IsCommonSubseq cs l1 l2 → (cs.length : Int) ≤ result)
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem LongestCommonSubsequence_spec_satisfied (str1 : String) (str2 : String) (h_precond : LongestCommonSubsequence_precond str1 str2) :
    LongestCommonSubsequence_postcond str1 str2 (LongestCommonSubsequence str1 str2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof