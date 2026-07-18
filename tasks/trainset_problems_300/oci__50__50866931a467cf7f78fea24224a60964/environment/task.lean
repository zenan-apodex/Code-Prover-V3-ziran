-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
def lookupKey : List (String × String) → String → Option String
  | [], _ => none
  | (k, v) :: xs, key => if k = key then some v else lookupKey xs key

def KeysNodup (xs : List (String × String)) : Prop :=
  (xs.map Prod.fst).Nodup
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def MergeDictionaries_precond (dict1 : List (String × String)) (dict2 : List (String × String)) : Prop :=
  -- !benchmark @start precond
  KeysNodup dict1 ∧ KeysNodup dict2
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def MergeDictionaries (dict1 : List (String × String)) (dict2 : List (String × String))
    (h_precond : MergeDictionaries_precond dict1 dict2) : List (String × String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def MergeDictionaries_postcond (dict1 : List (String × String)) (dict2 : List (String × String))
    (result : List (String × String)) (h_precond : MergeDictionaries_precond dict1 dict2) : Prop :=
  -- !benchmark @start postcond
  KeysNodup result ∧
  (∀ key val,
    lookupKey result key = some val ↔
      lookupKey dict2 key = some val ∨
        (lookupKey dict2 key = none ∧ lookupKey dict1 key = some val)) ∧
  (∀ key,
    lookupKey result key = none ↔
      lookupKey dict2 key = none ∧ lookupKey dict1 key = none)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem MergeDictionaries_spec_satisfied (dict1 : List (String × String)) (dict2 : List (String × String))
    (h_precond : MergeDictionaries_precond dict1 dict2) :
    MergeDictionaries_postcond dict1 dict2 (MergeDictionaries dict1 dict2 h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof