import Mathlib

inductive Expr where
  | value : Int → Expr
  | add : Expr → Expr → Expr
  | sub : Expr → Expr → Expr
  | mul : Expr → Expr → Expr
  | truediv : Expr → Expr → Expr
  | mod : Expr → Expr → Expr
  | pow : Expr → Expr → Expr
deriving Repr

def compute : Expr → Int
  | Expr.value n => n
  | Expr.add a b => compute a + compute b
  | Expr.sub a b => compute a - compute b
  | Expr.mul a b => compute a * compute b
  | Expr.truediv a b => compute a / compute b
  | Expr.mod a b => compute a % compute b
  | Expr.pow a b => compute a ^ (compute b).natAbs

theorem expr_compute_matches_operator (e : Expr) :
  match e with
  | Expr.value n => compute e = n
  | Expr.add a b => compute e = compute a + compute b
  | Expr.sub a b => compute e = compute a - compute b 
  | Expr.mul a b => compute e = compute a * compute b
  | Expr.truediv a b => compute e = compute a / compute b
  | Expr.mod a b => compute e = compute a % compute b 
  | Expr.pow a b => compute e = compute a ^ (compute b).natAbs
  := by sorry

theorem value_preserves_int (x : Int) :
  compute (Expr.value x) = x := by sorry 

theorem operator_composition (e₁ e₂ : Expr) :
  compute (Expr.add e₁ e₂) = compute e₁ + compute e₂ ∧
  compute (Expr.mul e₁ e₂) = compute e₁ * compute e₂ ∧ 
  compute (Expr.sub e₁ e₂) = compute e₁ - compute e₂ := by sorry
