-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux
-- !benchmark @end solution_aux

-- !benchmark @start precond_aux
-- !benchmark @end precond_aux

@[reducible, simp]
def RemoveHtmlTags_precond (html_string : String) : Prop :=
  -- !benchmark @start precond
  True
  -- !benchmark @end precond


-- !benchmark @start code_aux
-- !benchmark @end code_aux


def RemoveHtmlTags (html_string : String) (h_precond : RemoveHtmlTags_precond html_string) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code


-- !benchmark @start postcond_aux
inductive SkipHtmlTag : List Char → List Char → Prop where
  | end (cs : List Char) : SkipHtmlTag ('>' :: cs) cs
  | more (c : Char) (cs rest : List Char) :
      c ≠ '>' →
      SkipHtmlTag cs rest →
      SkipHtmlTag (c :: cs) rest

inductive RemovesHtmlTagsRel : List Char → List Char → Prop where
  | nil : RemovesHtmlTagsRel [] []
  | text (c : Char) (cs out : List Char) :
      c ≠ '<' →
      RemovesHtmlTagsRel cs out →
      RemovesHtmlTagsRel (c :: cs) (c :: out)
  | tag (cs rest out : List Char) :
      SkipHtmlTag cs rest →
      RemovesHtmlTagsRel rest out →
      RemovesHtmlTagsRel ('<' :: cs) out
  | unclosed (cs out : List Char) :
      (¬ ∃ rest, SkipHtmlTag cs rest) →
      RemovesHtmlTagsRel cs out →
      RemovesHtmlTagsRel ('<' :: cs) ('<' :: out)
-- !benchmark @end postcond_aux


@[reducible, simp]
def RemoveHtmlTags_postcond (html_string : String) (result : String)
    (h_precond : RemoveHtmlTags_precond html_string) : Prop :=
  -- !benchmark @start postcond
  RemovesHtmlTagsRel html_string.toList result.toList
  -- !benchmark @end postcond


-- !benchmark @start proof_aux
-- !benchmark @end proof_aux


theorem RemoveHtmlTags_spec_satisfied (html_string : String)
    (h_precond : RemoveHtmlTags_precond html_string) :
    RemoveHtmlTags_postcond html_string (RemoveHtmlTags html_string h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof