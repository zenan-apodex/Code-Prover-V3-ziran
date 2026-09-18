/- Trusted challenge introspection: runs only in the clean challenge container.
   Names come from Lean's elaborated environment, including namespaces/private names.
   Definition holes are original definitions whose body contains sorryAx. -/
import Lean
open Lean

def main (_ : List String) : IO Unit := do
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := `Main }] {}
  let some idx := env.getModuleIdx? `Main
    | throw <| .userError "Missing trusted Main module"
  let mut theorems : Array String := #[]
  let mut definitions : Array String := #[]
  for (name, info) in env.constants.toList do
    if env.getModuleIdxFor? name == some idx then
      match info with
      | .thmInfo _ => theorems := theorems.push name.toString
      | .defnInfo info =>
        if info.value.getUsedConstants.contains `sorryAx then
          definitions := definitions.push name.toString
      | _ => pure ()
  if theorems.isEmpty then
    throw <| .userError "Trusted task has no theorem targets"
  IO.println <| Json.compress <| Json.mkObj [
    ("theorem_names", toJson (theorems.qsort (· < ·))),
    ("definition_names", toJson (definitions.qsort (· < ·)))]
