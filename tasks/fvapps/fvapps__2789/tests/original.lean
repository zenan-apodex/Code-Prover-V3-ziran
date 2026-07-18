import Mathlib

inductive Category where
  | Underweight : Category
  | Normal : Category
  | Overweight : Category
  | Obese : Category
deriving BEq, Repr

def bmi (weight height : Float) : Category :=
  sorry

theorem bmi_returns_valid_category {weight height : Float} 
  (h1 : weight ≥ 1) (h2 : weight ≤ 500) 
  (h3 : height ≥ 0.5) (h4 : height ≤ 3.0) :
  let result := bmi weight height
  result = Category.Underweight ∨ 
  result = Category.Normal ∨
  result = Category.Overweight ∨ 
  result = Category.Obese :=
  sorry

theorem bmi_categories_are_monotonic {weight height : Float}
  (h1 : weight ≥ 1) (h2 : weight ≤ 500)
  (h3 : height ≥ 0.5) (h4 : height ≤ 3.0) :
  let bmiValue := weight / (height * height)
  (bmiValue ≤ 18.5 → bmi weight height = Category.Underweight) ∧
  (18.5 < bmiValue ∧ bmiValue ≤ 25 → bmi weight height = Category.Normal) ∧
  (25 < bmiValue ∧ bmiValue ≤ 30 → bmi weight height = Category.Overweight) ∧
  (30 < bmiValue → bmi weight height = Category.Obese) :=
  sorry

theorem bmi_zero_height_undefined {weight : Float} :
  ¬∃(result : Category), bmi weight 0 = result :=
  sorry
