import Mathlib

namespace CurryPartial

def add2 (x y : Int) : Int :=
  sorry

def add3 (x y z : Int) : Int :=
  sorry

def concat3 (x y z : α) : String :=
  sorry

def curry_partial : ((α → β) → (α → β)) :=
  sorry

theorem curry_preserves_binary_function (x y : Int) :
  curry_partial add2 x y = add2 x y :=
  sorry

theorem curry_preserves_ternary_function (x y z : Int) :
  curry_partial add3 x y z = add3 x y z :=
  sorry

theorem partial_application_preserves_result_1 (x y z : Int) :
  curry_partial add3 x y z = add3 x y z :=
  sorry

theorem partial_application_preserves_result_2 (x y z : Int) :
  curry_partial (curry_partial add3 x) y z = add3 x y z :=
  sorry

theorem nested_curry_calls (x y z : Int) :
  curry_partial (curry_partial (curry_partial add3 x) y) z = add3 x y z :=
  sorry

theorem curry_works_with_different_types {α : Type} (x y z : α) :
  curry_partial concat3 x y z = concat3 x y z :=
  sorry

end CurryPartial
