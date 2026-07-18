import Mathlib

def nth_char (words : List String) : String := sorry

theorem nth_char_output_length (words : List String) :
  words.all (fun w => w.length ≥ 10) →
  (nth_char words).length = words.length := sorry

theorem nth_char_chars_from_word_at_index (words : List String) (i : Fin words.length) :
  words ≠ [] →
  words.all (fun w => w.length ≥ 10) →
  (nth_char words).data.get? i.val = (words.get i).data.get? i.val := sorry

theorem nth_char_empty_list :
  nth_char [] = "" := sorry
