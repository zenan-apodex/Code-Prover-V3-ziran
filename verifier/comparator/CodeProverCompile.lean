/- Trusted elaboration support for Lean 4.28.
   Give protected declarations a deterministic matcher cache, then restore the
   editable context so subsequent proof tactics can reuse their implementation's
   matchers. This does not change declarations or comparison rules. -/
module
public import Lean
import all Lean.Meta.Match.Match

namespace CodeProver

private meta initialize savedMatcherExt : Lean.EnvExtension
    (Option (Lean.PHashMap Lean.Meta.Match.MatcherKey Lean.Name)) ←
  Lean.registerEnvExtension (pure none) (asyncMode := .local)

public meta def beginSpecification : Lean.Elab.Command.CommandElabM Unit := do
  Lean.modifyEnv fun env =>
    let saved := Lean.Meta.Match.matcherExt.getState env
    let env := savedMatcherExt.setState env (some saved)
    Lean.Meta.Match.matcherExt.setState env {}

public meta def endSpecification : Lean.Elab.Command.CommandElabM Unit := do
  Lean.modifyEnv fun env =>
    match savedMatcherExt.getState env with
    | none => env
    | some saved =>
      let merged := (Lean.Meta.Match.matcherExt.getState env).foldl
        (fun cache key name => if cache.contains key then cache else cache.insert key name) saved
      let env := savedMatcherExt.setState env none
      Lean.Meta.Match.matcherExt.setState env merged

end CodeProver
