-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def SpaceSeparatedWords (s : String) : List String :=
  (s.splitOn " ").filter fun w => w ≠ ""

def JoinedWithSingleSpaces (ws : List String) : String :=
  String.intercalate " " ws
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RearrangeWords_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def RearrangeWords (input_string : String) (h_precond : RearrangeWords_precond input_string) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def LexSortedStrings (ws : List String) : Prop :=
  List.Pairwise (fun a b => a ≤ b) ws
-- !benchmark @end postcond_aux

@[reducible, simp]
def RearrangeWords_postcond (input_string : String) (result : String)
    (h_precond : RearrangeWords_precond input_string) : Prop :=
  -- !benchmark @start postcond
  ∃ resultWords : List String,
    result = JoinedWithSingleSpaces resultWords ∧
    resultWords.Perm (SpaceSeparatedWords input_string) ∧
    LexSortedStrings resultWords
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem RearrangeWords_spec_satisfied (input_string : String)
    (h_precond : RearrangeWords_precond input_string) :
    RearrangeWords_postcond input_string (RearrangeWords input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof