-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def VendingMachine_precond (product : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def VendingMachine (product : String) (h_precond : VendingMachine_precond product) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
def ValidVendingProduct (product : String) : Prop :=
  product = "candy" ∨ product = "chips" ∨ product = "soda" ∨ product = "cookies"
-- !benchmark @end postcond_aux

@[reducible, simp]
def VendingMachine_postcond (product : String) (result : String)
    (h_precond : VendingMachine_precond product) : Prop :=
  -- !benchmark @start postcond
  (product = "candy" → result = "The cost of candy is $1.00.") ∧
  (product = "chips" → result = "The cost of chips is $1.25.") ∧
  (product = "soda" → result = "The cost of soda is $1.50.") ∧
  (product = "cookies" → result = "The cost of cookies is $1.75.") ∧
  (¬ ValidVendingProduct product → result = "Invalid product selection. Please try again.")
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem VendingMachine_spec_satisfied (product : String)
    (h_precond : VendingMachine_precond product) :
    VendingMachine_postcond product (VendingMachine product h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof