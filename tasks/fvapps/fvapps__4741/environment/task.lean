import Mathlib

def isLower (c : Char) : Bool := sorry
def isUpper (c : Char) : Bool := sorry
def pseudo_sort (s : String) : String := sorry

theorem pseudo_sort_preserves_words {word_list : List String} (h : word_list ≠ []) :
  let sentence := String.intercalate " " word_list
  let result := pseudo_sort sentence
  let orig_words := word_list.filter (λ w => w.trim ≠ "")
  let result_words := (result.split (· = ' ')).filter (λ w => w.trim ≠ "")
  ∀ w, w ∈ orig_words ↔ w ∈ result_words := sorry

theorem pseudo_sort_ordering {word_list : List String} (h : word_list ≠ []) :
  let sentence := String.intercalate " " word_list
  let result := (pseudo_sort sentence).split (· = ' ')
  let lowercase := result.filter (λ w => !w.isEmpty ∧ isLower (w.front))
  let uppercase := result.filter (λ w => !w.isEmpty ∧ isUpper (w.front))
  (∀ x y, x ∈ lowercase → y ∈ lowercase → x.data < y.data → result.indexOf x < result.indexOf y) ∧ 
  (∀ x y, x ∈ uppercase → y ∈ uppercase → x.data < y.data → result.indexOf x > result.indexOf y) ∧
  (∀ l u, l ∈ lowercase → u ∈ uppercase → result.indexOf l < result.indexOf u) := sorry

theorem pseudo_sort_handles_punctuation (text : String) :
  let result := pseudo_sort text
  ∀ c, c ∈ "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~".data → 
    ¬(c ∈ result.data) := sorry
