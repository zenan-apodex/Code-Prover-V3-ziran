import Mathlib

def find_longest_distance (k : Int) (arr : List Int) : Int := sorry

-- Value not in array gives 0 distance
theorem missing_value_distance 
  {k : Int} {arr : List Int} 
  (h : ¬ k ∈ arr) : 
  find_longest_distance k arr = 0 := sorry

-- Distance is always non-negative  
theorem distance_non_negative
  (k : Int) (arr : List Int) :
  find_longest_distance k arr ≥ 0 := sorry

-- Distance is bounded by array length minus 1
theorem distance_upper_bound 
  (k : Int) (arr : List Int) :
  find_longest_distance k arr ≤ max (arr.length - 1) 0 := sorry

-- Function to find last index
def findLastIndex (p : α → Bool) (l : List α) : Option Nat :=
  let indexed := List.enumFrom 0 l
  (indexed.find? (fun (i, x) => p x)).map Prod.fst

-- Distance equals last occurrence minus first occurrence
theorem distance_matches_occurrences 
  (k : Int) (arr : List Int) :
  find_longest_distance k arr = 
    let first := arr.findIdx? (· = k)
    let last := findLastIndex (· = k) arr
    match first, last with
    | some i, some j => j - i 
    | _, _ => 0 := sorry
