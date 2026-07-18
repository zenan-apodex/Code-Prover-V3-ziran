-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
def KeysUnique (d : List (String × Int)) : Prop :=
  (d.map Prod.fst).Nodup
-- !benchmark @end precond_aux

@[reducible, simp]
def SortDictByValuesDesc_precond (d : List (String × Int)) : Prop :=
  -- !benchmark @start precond
  KeysUnique d
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def SortDictByValuesDesc (d : List (String × Int)) (h_precond : SortDictByValuesDesc_precond d) : List (String × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def NonIncreasingByValue (xs : List (String × Int)) : Prop :=
  List.Pairwise (fun a b => b.2 ≤ a.2) xs
-- !benchmark @end postcond_aux

@[reducible, simp]
def SortDictByValuesDesc_postcond (d : List (String × Int)) (result : List (String × Int))
    (h_precond : SortDictByValuesDesc_precond d) : Prop :=
  -- !benchmark @start postcond
  result.Perm d ∧
  NonIncreasingByValue result
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem SortDictByValuesDesc_spec_satisfied (d : List (String × Int))
    (h_precond : SortDictByValuesDesc_precond d) :
    SortDictByValuesDesc_postcond d (SortDictByValuesDesc d h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof