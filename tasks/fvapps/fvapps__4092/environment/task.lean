import Mathlib

/-- A helper function, not the actual main --/
def combine (verb: String) (noun: String) : String := sorry

theorem combine_concatenation (verb noun: String) : 
  combine verb noun = verb ++ noun := sorry

theorem combine_length (verb noun: String) : 
  (combine verb noun).length = verb.length + noun.length := sorry 

theorem combine_contains_inputs (verb noun: String) 
  (h1: verb.length > 0) (h2: noun.length > 0) :
  ∃ i₁ i₂, (combine verb noun).data.get? i₁ = some verb.data.head! ∧
          (combine verb noun).data.get? i₂ = some noun.data.head! := sorry
