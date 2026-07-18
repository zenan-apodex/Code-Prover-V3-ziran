-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
/-- `StripTagsAux inside inp out` means that scanning the character list `inp`
from left to right, with `inside = true` meaning we are currently inside an
HTML tag and `inside = false` meaning we are outside tags, produces exactly the
character list `out` after removing all tag characters and all characters
strictly between `<` and the next `>`. -/
inductive StripTagsAux : Bool → List Char → List Char → Prop where
  | nil (inside : Bool) :
      StripTagsAux inside [] []
  | enterTag {xs ys} :
      StripTagsAux true xs ys →
      StripTagsAux false ('<' :: xs) ys
  | keepChar {c : Char} {xs ys} :
      c ≠ '<' →
      StripTagsAux false xs ys →
      StripTagsAux false (c :: xs) (c :: ys)
  | leaveTag {xs ys} :
      StripTagsAux false xs ys →
      StripTagsAux true ('>' :: xs) ys
  | skipInTag {c : Char} {xs ys} :
      c ≠ '>' →
      StripTagsAux true xs ys →
      StripTagsAux true (c :: xs) ys
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemoveHtmlTags_precond (input_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond

-- !benchmark @start code_aux
-- !benchmark @end code_aux

def RemoveHtmlTags (input_string : String) (h_precond : RemoveHtmlTags_precond input_string) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux
-- !benchmark @end postcond_aux

@[reducible, simp]
def RemoveHtmlTags_postcond (input_string : String) (result : String)
    (h_precond : RemoveHtmlTags_precond input_string) : Prop :=
  -- !benchmark @start postcond
  StripTagsAux false input_string.toList result.toList
  -- !benchmark @end postcond

-- !benchmark @start proof_aux
-- !benchmark @end proof_aux

theorem RemoveHtmlTags_spec_satisfied (input_string : String)
    (h_precond : RemoveHtmlTags_precond input_string) :
    RemoveHtmlTags_postcond input_string (RemoveHtmlTags input_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof