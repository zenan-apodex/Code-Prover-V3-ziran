import Mathlib
import Std.Data.HashMap

-- === BEGIN: shared helper definitions (provided) ===
/--
name: balanced_paren_non_computable
use: |
  Non-computable definition to check if a string is balanced with respect to parentheses.
problems:
  - 1
  - 6
  - 132
sample_problems:
  - 0
-/
def balanced_paren_non_computable
(paren_string: String) (bracket_type_left : Char) (bracket_type_right: Char): Prop
:=
let chars := paren_string.toList;
(∀ (i : ℕ), i ≤ chars.length → ((chars.take i).count bracket_type_right) ≤ ((chars.take i).count bracket_type_left)) ∧
(chars.count bracket_type_left = chars.count bracket_type_right)

/-- Helper: maximum paren nesting depth over a list of chars.
    (v4.28-clean rewrite: recurses structurally on `List Char`.) -/
def count_max_paren_depth_helperList (chars : List Char) (num_open : Int) (max_depth : Nat) : Nat :=
  match chars with
  | [] => max_depth
  | c :: rest =>
    if c == '(' then
      let new_num_open := num_open + 1
      count_max_paren_depth_helperList rest new_num_open (max_depth.max new_num_open.toNat)
    else if c == ')' then count_max_paren_depth_helperList rest (num_open - 1) max_depth
    else count_max_paren_depth_helperList rest num_open max_depth

def count_max_paren_depth_helper (paren_string : String) (num_open : Int) (max_depth : Nat) : Nat :=
  count_max_paren_depth_helperList paren_string.toList num_open max_depth

def count_max_paren_depth (paren_string : String) : Nat :=
  count_max_paren_depth_helper paren_string 0 0
-- === END: shared helper definitions ===

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(implementation: String → List Nat)
-- inputs
(paren_string: String)
:=
-- spec
let spec (result: List Nat) :=
let paren_space_split := paren_string.split (fun x => x = ' ');
result.length = paren_space_split.length ∧
∀ i, i < result.length →
let group := paren_space_split[i]!;
balanced_paren_non_computable group '(' ')' →
count_max_paren_depth group = result[i]!;
-- program termination
∃ result, implementation paren_string = result ∧
spec result
-- end_def problem_spec
-- === END: SPEC ===

-- === BEGIN: IMPLEMENTATION (fill in) ===
-- start_def implementation_signature
def implementation (paren_string: String) : List Nat :=
-- end_def implementation_signature
-- !benchmark @start code
  sorry
-- !benchmark @end code
-- === END: IMPLEMENTATION ===

-- === BEGIN: CORRECTNESS (prove) ===
-- start_def correctness_definition
theorem correctness
(paren_string: String)
: problem_spec implementation paren_string
:=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
