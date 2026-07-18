import Mathlib

inductive Base where
  | A : Base
  | T : Base
  | C : Base
  | G : Base
deriving BEq, Repr

def DNA_strand : List Base → List Base
  | xs => sorry

theorem dna_complement_length {xs : List Base} :
  (DNA_strand xs).length = xs.length := by sorry

theorem dna_complement_involution {xs : List Base} :
  DNA_strand (DNA_strand xs) = xs := by sorry

theorem dna_complement_maps_correctly {xs : List Base} {i : Nat} (h : i < xs.length) :
  match xs.get ⟨i, h⟩ with
  | Base.A => (DNA_strand xs).get ⟨i, by {rw [dna_complement_length]; exact h}⟩ = Base.T
  | Base.T => (DNA_strand xs).get ⟨i, by {rw [dna_complement_length]; exact h}⟩ = Base.A
  | Base.C => (DNA_strand xs).get ⟨i, by {rw [dna_complement_length]; exact h}⟩ = Base.G
  | Base.G => (DNA_strand xs).get ⟨i, by {rw [dna_complement_length]; exact h}⟩ = Base.C
  := by sorry
