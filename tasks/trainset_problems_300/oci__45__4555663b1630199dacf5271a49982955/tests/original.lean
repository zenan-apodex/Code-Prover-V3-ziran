-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def UniqueKeys (input_dict : List (String × Int)) : Prop :=
  List.Nodup (input_dict.map Prod.fst)

def UniqueValues (input_dict : List (String × Int)) : Prop :=
  List.Nodup (input_dict.map Prod.snd)
-- !benchmark @end precond_aux

@[reducible, simp]
def SwapKeysValues_precond (input_dict : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  UniqueKeys input_dict ∧ UniqueValues input_dict
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SwapKeysValues (input_dict : List (String × Int))
    (h_precond : SwapKeysValues_precond input_dict) : List (Int × String) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def SwapKeysValues_postcond (input_dict : List (String × Int))
    (result : List (Int × String))
    (h_precond : SwapKeysValues_precond input_dict) : Prop :=
  -- !benchmark @start postcond
  (∀ k : String, ∀ v : Int, (k, v) ∈ input_dict ↔ (v, k) ∈ result) ∧
  List.Nodup (result.map Prod.fst) ∧
  List.Nodup (result.map Prod.snd)
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SwapKeysValues_spec_satisfied (input_dict : List (String × Int))
    (h_precond : SwapKeysValues_precond input_dict) :
    SwapKeysValues_postcond input_dict (SwapKeysValues input_dict h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof