import Mathlib

def process_angen_operations (nums: List Int) (operations: List (Char × String × String)) : List String :=
  sorry

theorem process_operations_basic_props 
  (nums: List Int) 
  (operations: List (Char × String × String))
  (h1: nums.length ≥ 1)
  (h2: ∀ op ∈ operations, 
    (toString op.1 = "U" ∨ toString op.1 = "A" ∨ toString op.1 = "M" ∨ 
     toString op.1 = "m" ∨ toString op.1 = "S" ∨ toString op.1 = "s") ∧
    ((String.toNat! op.2.1) ≤ nums.length) ∧  
    ((String.toNat! op.2.2) ≤ nums.length) ∧
    ((String.toNat! op.2.1) ≤ (String.toNat! op.2.2))) :
  let results := process_angen_operations nums operations
  ∀ r ∈ results, r.length > 0 :=
sorry

theorem process_operations_arithmetic 
  (nums: List Int)
  (operations: List (Char × String × String))
  (h1: nums.length ≥ 1)
  (op: Char × String × String)
  (h2: op ∈ operations)
  (h3: op.1 = 'A' ∨ op.1 = 'M' ∨ op.1 = 'm') :
  let l := (String.toNat! op.2.1) - 1
  let r := String.toNat! op.2.2
  let subarray := nums.take r |>.drop l
  let result := (process_angen_operations nums operations)[operations.indexOf op]!
  match op.1 with
  | 'A' => result = toString (subarray.foldl (· + ·) 0)
  | 'M' => result = toString (List.maximum? subarray |>.get!)
  | 'm' => result = toString (List.minimum? subarray |>.get!)
  | _ => True :=
sorry

theorem process_invalid_operations
  (nums: List Int)
  (operations: List (Char × String × String))
  (h1: nums.length ≥ 1)
  (h2: ∀ op ∈ operations, 
    op.1 ≠ 'U' ∧ op.1 ≠ 'A' ∧ op.1 ≠ 'M' ∧ 
    op.1 ≠ 'm' ∧ op.1 ≠ 'S' ∧ op.1 ≠ 's') :
  let results := process_angen_operations nums operations
  ∀ r ∈ results, r = "!!!" :=
sorry

theorem process_second_extremes
  (nums: List Int)
  (operations: List (Char × String × String))
  (h1: nums.length ≥ 1) 
  (op: Char × String × String)
  (h2: op ∈ operations)
  (h3: op.1 = 'S' ∨ op.1 = 's')
  (h4: (String.toNat! op.2.1) ≤ nums.length)
  (h5: (String.toNat! op.2.2) ≤ nums.length)
  (h6: (String.toNat! op.2.1) ≤ (String.toNat! op.2.2)) :
  let l := (String.toNat! op.2.1) - 1
  let r := String.toNat! op.2.2
  let subarray := nums.take r |>.drop l
  let result := (process_angen_operations nums operations)[operations.indexOf op]!
  (List.length subarray < 2 → result = "NA") ∧
  (List.length subarray ≥ 2 →
    match op.1 with
    | 's' => result.toInt? |>.map (λ x => x ≥ (List.minimum? subarray |>.get!)) |>.getD false
    | 'S' => result.toInt? |>.map (λ x => x ≤ (List.maximum? subarray |>.get!)) |>.getD false
    | _ => True) :=
sorry
