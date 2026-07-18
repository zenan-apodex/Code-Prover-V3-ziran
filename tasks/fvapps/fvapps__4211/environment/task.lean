import Mathlib

inductive Perm {α : Type u} : List α → List α → Prop where
  | nil : Perm [] []
  | cons (x : α) {l₁ l₂ : List α} : Perm l₁ l₂ → Perm (x::l₁) (x::l₂)
  | swap (x y : α) (l : List α) : Perm (x::y::l) (y::x::l)
  | trans {l₁ l₂ l₃ : List α} : Perm l₁ l₂ → Perm l₂ l₃ → Perm l₁ l₃

def validate_word (s : String) : Bool := sorry

theorem permutations_invariant (s₁ s₂ : String) : 
  Perm s₁.toList s₂.toList → validate_word s₁ = validate_word s₂ := sorry

theorem repeat_string_equiv (s : String) (n : Nat) :
  n > 0 → validate_word (String.join (List.replicate n s)) = validate_word s := sorry 

theorem single_char_string_valid (c : Char) (n : Nat) :
  n > 0 → validate_word (String.mk (List.replicate n c)) = true := sorry
