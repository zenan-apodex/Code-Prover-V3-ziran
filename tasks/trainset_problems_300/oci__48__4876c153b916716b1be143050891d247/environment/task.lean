-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def AreAllAnagrams_precond (words : List String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
def StringAnagram (s t : String) : Prop :=
  s.data.Perm t.data
-- !benchmark @end code_aux

def AreAllAnagrams (words : List String) (h_precond : AreAllAnagrams_precond words) : Bool :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def AreAllAnagrams_postcond (words : List String) (result : Bool)
    (h_precond : AreAllAnagrams_precond words) : Prop :=
  -- !benchmark @start postcond
  (result = true) ↔
    ∀ w₁ ∈ words, ∀ w₂ ∈ words, StringAnagram w₁ w₂
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem AreAllAnagrams_spec_satisfied (words : List String)
    (h_precond : AreAllAnagrams_precond words) :
    AreAllAnagrams_postcond words (AreAllAnagrams words h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof