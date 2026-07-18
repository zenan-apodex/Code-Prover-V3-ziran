import Mathlib

def Heap := List Int

def ins (l : Heap) (x : Int) : Heap := sorry 
def pop (l : Heap) : Int × Heap := sorry

/-- The heap maintains the min-heap property after insertions -/
theorem heap_maintains_min_property {h : Heap} (xs : List Int) : 
  let h' := xs.foldl (fun acc x => ins acc x) h
  ∀ i, 2 ≤ i → i < h'.length → 
    match h'.get? i, h'.get? (i/2) with
    | some vi, some vp => vi ≥ vp
    | _, _ => True := sorry

/-- The heap extracts elements in sorted order -/
theorem heap_gives_sorted_output {h : Heap} (xs : List Int) :
  let h' := xs.foldl (fun acc x => ins acc x) h
  let rec extract (h : Heap) (n : Nat) : List Int :=
    match n with
    | 0 => []
    | n+1 => match pop h with
      | (x, h') => x :: extract h' n
  ∀ i j, i < j → j < (extract h' h'.length).length → 
    (extract h' h'.length).get? i = some xi →
    (extract h' h'.length).get? j = some xj →
    xi ≤ xj := sorry

/-- Single value insertion and extraction works correctly -/
theorem heap_single_value (x : Int) :
  let h := ins [] x
  pop h = (x, []) := sorry
