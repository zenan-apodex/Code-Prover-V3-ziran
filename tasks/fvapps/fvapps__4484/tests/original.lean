import Mathlib

inductive Operation where
  | add : Operation
  | sub : Operation
  | mul : Operation
  | div : Operation
deriving Repr

def calculate (x: Float) (op: Operation) (y: Float) : Option Float :=
  sorry

theorem calculator_valid_ops {x y : Float} {op : Operation} :
  let result := calculate x op y
  match op with
  | Operation.add => result = some (x + y)
  | Operation.sub => result = some (x - y) 
  | Operation.mul => result = some (x * y)
  | Operation.div => result = some (x / y) ∨ result = none
  := sorry

theorem calculator_div_by_zero {x : Float} :
  calculate x Operation.div 0 = none := sorry

theorem calculator_outputs_valid {x y : Float} {op : Operation} :
  ∃ (r: Float), calculate x op y = some r ∨ calculate x op y = none := sorry
