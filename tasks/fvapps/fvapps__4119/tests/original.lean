import Mathlib

def valid_emotions := [":D", ":)", ":|", ":(", "T_T"]

def sort_emotions (emotions : List String) (ascending : Bool) : List String :=
  sorry

theorem sort_emotions_length_preserved 
  (emotions : List String) (ascending : Bool) : 
  List.length (sort_emotions emotions ascending) = List.length emotions :=
  sorry

theorem sort_emotions_elements_preserved 
  (emotions : List String) (ascending : Bool) :
  List.all (sort_emotions emotions ascending) (· ∈ emotions) ∧ 
  List.all emotions (· ∈ sort_emotions emotions ascending) :=
  sorry

theorem sort_emotions_ascending_ordered
  (emotions : List String) (h : List.length emotions > 1) :
  let result := sort_emotions emotions true
  ∀ i, ∀ h : i + 1 < result.length,
    let idx₁ := ⟨i, Nat.lt_trans (Nat.lt_succ_self i) h⟩
    let idx₂ := ⟨i + 1, h⟩
    let pos₁ := valid_emotions.indexOf (result.get idx₁)
    let pos₂ := valid_emotions.indexOf (result.get idx₂)
    pos₁ ≤ pos₂ :=
  sorry

theorem sort_emotions_descending_ordered
  (emotions : List String) (h : List.length emotions > 1) :
  let result := sort_emotions emotions false
  ∀ i, ∀ h : i + 1 < result.length,
    let idx₁ := ⟨i, Nat.lt_trans (Nat.lt_succ_self i) h⟩
    let idx₂ := ⟨i + 1, h⟩
    let pos₁ := valid_emotions.indexOf (result.get idx₁)
    let pos₂ := valid_emotions.indexOf (result.get idx₂)
    pos₁ ≥ pos₂ :=
  sorry

theorem sort_emotions_empty (ascending : Bool) :
  sort_emotions [] ascending = [] :=
  sorry

theorem sort_emotions_single (emotion : String) (ascending : Bool)
  (h : emotion ∈ valid_emotions) :
  sort_emotions [emotion] ascending = [emotion] :=
  sorry
