import Mathlib

inductive Status where
  | LIVE
  | DEAD
  deriving BEq, Repr

instance : Inhabited Status where
  default := Status.DEAD

structure Command where
  server: Nat 
  success: Nat
  failure: Nat
deriving Repr

def check_servers_alive (cmds: List Command) : List Status := sorry

theorem check_servers_alive_length (cmds: List Command) : 
  cmds.length > 0 → (check_servers_alive cmds).length = 2 := sorry

theorem check_servers_alive_valid_statuses (cmds: List Command) :
  cmds.length > 0 → ∀ s ∈ check_servers_alive cmds, s = Status.LIVE ∨ s = Status.DEAD := sorry

def isLive (total: Nat) (failures: Nat) : Bool :=
  total = 0 || (total - failures ≥ total / 2)

theorem check_servers_alive_server_a (cmds: List Command) (ta da: Nat) :
  ta = (cmds.filter (λ c => c.server = 1)).foldr (λ c acc => c.success + c.failure + acc) 0 →
  da = (cmds.filter (λ c => c.server = 1)).foldr (λ c acc => c.failure + acc) 0 →
  cmds.length > 0 →
  (check_servers_alive cmds)[0]! = 
    if isLive ta da then Status.LIVE else Status.DEAD := sorry

theorem check_servers_alive_server_b (cmds: List Command) (tb db: Nat) :
  tb = (cmds.filter (λ c => c.server = 2)).foldr (λ c acc => c.success + c.failure + acc) 0 →
  db = (cmds.filter (λ c => c.server = 2)).foldr (λ c acc => c.failure + acc) 0 →
  cmds.length > 0 →
  (check_servers_alive cmds)[1]! = 
    if isLive tb db then Status.LIVE else Status.DEAD := sorry

theorem check_servers_alive_all_success (n: Nat) :
  n > 0 →
  check_servers_alive [(Command.mk 1 n 0), (Command.mk 2 n 0)] = [Status.LIVE, Status.LIVE] := sorry
