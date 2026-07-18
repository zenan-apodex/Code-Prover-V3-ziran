import Mathlib

structure HashMap (α β : Type) where
  size : Nat := 0
  get : α → Option β := fun _ => none
  contains : α → β → Bool := fun _ _ => false
  values : List β := []

def user_contacts (contacts : List (List String)) : 
  HashMap String (Option Int) := sorry

theorem all_missing_zips (names : List String) :
    let contacts := names.map (fun name => [name])
    let result := user_contacts contacts
    contacts.length = result.size ∧ 
    ∀ k, result.get k = none ∨ result.get k = some none := sorry

theorem all_have_zips (contacts : List (String × Int))
    (h₁ : ∀ (p₁ p₂ : String × Int), p₁ ∈ contacts → p₂ ∈ contacts → p₁ ≠ p₂ → p₁.1 ≠ p₂.1)
    (h₂ : ∀ pair ∈ contacts, 10000 ≤ pair.2 ∧ pair.2 ≤ 99999) :
    let result := user_contacts (contacts.map (fun p => [p.1, toString p.2]))
    contacts.length = result.size ∧
    (∀ k, (result.get k).isSome → (Option.get! (result.get k)).isSome) ∧
    (∀ pair ∈ contacts, result.get pair.1 = some (some pair.2)) := sorry
