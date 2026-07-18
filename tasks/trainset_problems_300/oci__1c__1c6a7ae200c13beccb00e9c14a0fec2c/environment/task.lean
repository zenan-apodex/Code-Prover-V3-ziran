-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def GeneratePairs_precond (a : Int) (b : Int) : Prop :=
  -- !benchmark @start precond
  0 < a ∧ a ≤ b
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def GeneratePairs (a : Int) (b : Int) (h_precond : GeneratePairs_precond a b) :
    List (Int × Int × String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
def GeneratePairsParityLabel (x y : Int) (s : String) : Prop :=
  ((x + y) % 2 = 0 ∧ s = "even") ∨
  ((x + y) % 2 ≠ 0 ∧ s = "odd")

def GeneratePairsEntryValid (a b : Int) (p : Int × Int × String) : Prop :=
  a ≤ p.1 ∧ p.1 ≤ b ∧
  a ≤ p.2.1 ∧ p.2.1 ≤ b ∧
  GeneratePairsParityLabel p.1 p.2.1 p.2.2

def GeneratePairsLexLt (p q : Int × Int × String) : Prop :=
  p.1 < q.1 ∨ (p.1 = q.1 ∧ p.2.1 < q.2.1)
-- !benchmark @end postcond_aux


@[reducible, simp]
def GeneratePairs_postcond (a : Int) (b : Int) (result : List (Int × Int × String))
    (h_precond : GeneratePairs_precond a b) : Prop :=
  -- !benchmark @start postcond
  (∀ p ∈ result, GeneratePairsEntryValid a b p) ∧
  (∀ x y : Int, a ≤ x → x ≤ b → a ≤ y → y ≤ b →
    ∃ s : String, (x, y, s) ∈ result ∧ GeneratePairsParityLabel x y s) ∧
  List.Pairwise GeneratePairsLexLt result
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem GeneratePairs_spec_satisfied (a : Int) (b : Int)
    (h_precond : GeneratePairs_precond a b) :
    GeneratePairs_postcond a b (GeneratePairs a b h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof