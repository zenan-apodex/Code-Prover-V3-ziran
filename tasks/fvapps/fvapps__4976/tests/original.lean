import Mathlib

def search (titles : List String) (term : String) : List String :=
  sorry

def containsInsensitive (s₁ s₂ : String) : Bool :=
  sorry

theorem search_case_insensitive (titles : List String) (term : String) :
  ∀ t ∈ search titles term, containsInsensitive t term = true := by
  sorry

theorem search_returns_subset (titles : List String) (term : String) :
  ∀ t ∈ search titles term, t ∈ titles := by
  sorry
  
theorem search_order_preserved (titles : List String) (term : String) :
  let result := search titles term
  ∀ i j, i < j → i < result.length → j < result.length → 
    (titles.indexOf (result[i]!) < titles.indexOf (result[j]!)) := by
  sorry
  
theorem search_empty_term (titles : List String) :
  search titles "" = titles := by
  sorry
  
theorem search_empty_titles (term : String) :
  search [] term = [] := by
  sorry
