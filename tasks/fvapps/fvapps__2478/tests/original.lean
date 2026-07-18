import Mathlib

inductive Perm (s₁ s₂ : String) : Prop where
  | mk : Perm s₁ s₂

def sumList : List Nat → Nat 
  | [] => 0
  | x :: xs => x + sumList xs

def find_the_difference (s t : String) : Char := sorry

theorem find_difference_finds_added_char (s : String) (extra_char : Char) :
  find_the_difference s (s.push extra_char) = extra_char := sorry

theorem find_difference_order_independent (s : String) (t : String) (extra_char : Char) 
    (h : t = s.push extra_char) :
  ∀ perm : String, Perm t perm → find_the_difference s perm = extra_char := sorry

theorem find_difference_empty_source (c : Char) :
  find_the_difference "" (String.mk [c]) = c := sorry

theorem find_difference_ord_sum (s : String) (extra_char : Char) :
  let t := s.push extra_char
  Char.toNat (find_the_difference s t) = 
    sumList (t.data.map Char.toNat) - sumList (s.data.map Char.toNat) := sorry
