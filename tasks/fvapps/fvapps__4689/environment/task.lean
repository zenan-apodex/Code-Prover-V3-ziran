import Mathlib

def createReport (names : List String) : List (String ⊕ Nat) :=
  sorry

theorem report_structure {names : List String} 
  (h : createReport names ≠ [Sum.inl "Disqualified data"]) :
  let result := createReport names;
  -- Result is a list
  (List.length result % 2 = 0)  
  -- Every even index is String, odd index is Nat > 0
  ∧ (∀ i, i < List.length result → 
      i % 2 = 0 → (∃ s : String, result.get! i = Sum.inl s)
      ∧ i % 2 = 1 → (∃ n : Nat, result.get! i = Sum.inr n ∧ n > 0)) :=
sorry

theorem sorted_codes {names : List String} 
  (h : createReport names ≠ [Sum.inl "Disqualified data"]) :
  let strings := List.filterMap (fun x => match x with 
    | Sum.inl s => some s
    | _ => none) (createReport names);
  List.Pairwise (fun x y => x ≤ y) strings :=
sorry

theorem labrador_disqualification {names : List String} 
  (h : ∃ entry ∈ names, entry = "Labrador Duck 1") :
  createReport names = [Sum.inl "Disqualified data"] :=
sorry
