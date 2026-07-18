-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
@[reducible, simp]
def get2d (a : Array (Array Int)) (i j : Int) : Int :=
  (a[Int.toNat i]!)[Int.toNat j]!
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def SlopeSearch_precond (a : Array (Array Int)) (key : Int) : Prop :=
  -- !benchmark @start precond
  a.size > 0 ∧
  (a[0]!).size > 0 ∧  -- non-empty inner arrays
  List.Pairwise (·.size = ·.size) a.toList ∧
  a.all (fun x => List.Pairwise (· ≤ ·) x.toList) ∧
  (List.range (a[0]!.size)).all (fun i =>
    List.Pairwise (· ≤ ·) (a.map (fun x => x[i]!)).toList
  )
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def SlopeSearch (a : Array (Array Int)) (key : Int) (h_precond : SlopeSearch_precond (a) (key)) : (Int × Int) :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible, simp]
def SlopeSearch_postcond (a : Array (Array Int)) (key : Int) (result: (Int × Int)) (h_precond : SlopeSearch_precond (a) (key)) :=
  -- !benchmark @start postcond
  let (m, n) := result;
  (m ≥ 0 ∧ m < a.size ∧ n ≥ 0 ∧ n < (a[0]!).size ∧ get2d a m n = key) ∨
  (m = -1 ∧ n = -1 ∧ a.all (fun x => x.all (fun e => e ≠ key)))
  -- !benchmark @end postcond


-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem SlopeSearch_spec_satisfied (a: Array (Array Int)) (key: Int) (h_precond : SlopeSearch_precond (a) (key)) :
    SlopeSearch_postcond (a) (key) (SlopeSearch (a) (key) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof
