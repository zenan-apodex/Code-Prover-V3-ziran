import Mathlib

inductive Matrix where
  | mk : List (List Int) → Matrix
deriving Repr

def minFlips (mat: Matrix) : Int :=
  sorry

theorem minflips_result_valid (mat: Matrix) : 
  minFlips mat ≥ -1 :=
  sorry

def isZeroMatrix (m: Matrix) : Bool :=
  match m with
  | Matrix.mk rows => rows.all (fun row => row.all (fun x => x = 0))

theorem minflips_zero_matrix (mat: Matrix)
  (h: isZeroMatrix mat = true) :
  minFlips mat = 0 :=
  sorry

def flipCells (mat: Matrix) (state: Nat) : Matrix :=
  sorry

theorem minflips_minus_one_means_impossible (mat: Matrix)
  (h: minFlips mat = -1) :
  ∀ state, ¬ isZeroMatrix (flipCells mat state) :=
  sorry

def isOnesMatrix (m: Matrix) : Bool := 
  match m with
  | Matrix.mk rows => rows.all (fun row => row.all (fun x => x = 1))

theorem minflips_ones_matrix_valid (mat: Matrix)
  (h: isOnesMatrix mat = true) :
  minFlips mat ≥ -1 :=
  sorry
