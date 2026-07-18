import Mathlib
import Std.Data.HashMap

-- === BEGIN: SPEC (provided) ===
-- start_def problem_spec
def problem_spec
-- function signature
(impl: String → List String → String)
-- inputs
(class_name: String)
(extensions: List String) :=
let strength (extension: String) :=
  let cap := (extension.toList.filter (fun c => c.isUpper)).length;
  let sm := (extension.toList.filter (fun c => c.isLower)).length;
  cap - sm;
-- spec
let spec (result: String) :=
let last_pos := result.revPosOf '.';
0 < extensions.length ∧ extensions.all (fun x => 0 < x.length) ∧ 0 < class_name.length →
0 < result.length ∧
last_pos.isSome ∧
let class_name' := result.take (last_pos.get!).byteIdx;
let extension_name := result.drop ((last_pos.get!).byteIdx + 1);
class_name' = class_name ∧
extension_name ∈ extensions ∧
let strength_of_extensions := extensions.map (fun ext => strength ext);
∃ j : Nat, j < extensions.length ∧
  extensions[j]! = extension_name ∧
  (∀ i : Nat, i < j → strength_of_extensions[i]! < strength_of_extensions[j]!)
  ∧ strength_of_extensions[j]! = strength_of_extensions.max?.get!;
-- program terminates
∃ result, impl class_name extensions = result ∧
-- return value satisfies spec
spec result
-- end_def problem_spec
-- === END: SPEC ===

-- === BEGIN: IMPLEMENTATION (fill in) ===
-- start_def implementation_signature
def implementation (class_name: String) (extensions: List String) : String :=
-- end_def implementation_signature
-- !benchmark @start code
  sorry
-- !benchmark @end code
-- === END: IMPLEMENTATION ===

-- === BEGIN: CORRECTNESS (prove) ===
-- start_def correctness_definition
theorem correctness
(class_name: String)
(extensions: List String)
: problem_spec implementation class_name extensions :=
-- end_def correctness_definition
-- !benchmark @start proof
  sorry
-- !benchmark @end proof
-- === END: CORRECTNESS ===
