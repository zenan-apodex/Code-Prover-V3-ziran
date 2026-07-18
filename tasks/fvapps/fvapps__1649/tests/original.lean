import Mathlib

inductive TCPState where
  | CLOSED
  | LISTEN
  | SYN_RCVD 
  | SYN_SENT
  | ESTABLISHED
  | FIN_WAIT_1
  | FIN_WAIT_2
  | CLOSING
  | TIME_WAIT
  | CLOSE_WAIT
  | LAST_ACK
  | ERROR
deriving Repr, BEq

inductive TCPEvent where
  | APP_PASSIVE_OPEN
  | APP_ACTIVE_OPEN
  | APP_SEND
  | APP_CLOSE
  | APP_TIMEOUT
  | RCV_SYN
  | RCV_ACK
  | RCV_SYN_ACK
  | RCV_FIN
  | RCV_FIN_ACK
deriving Repr, BEq

def traverse_TCP_states : List TCPEvent → TCPState 
  | _ => sorry

theorem traverse_TCP_states_valid (events : List TCPEvent) :
  traverse_TCP_states events ≠ TCPState.ERROR → 
  ∃ s, traverse_TCP_states events = s :=
sorry

theorem traverse_TCP_states_empty : 
  traverse_TCP_states [] = TCPState.CLOSED :=
sorry

theorem traverse_TCP_states_deterministic (events : List TCPEvent) :
  traverse_TCP_states events = traverse_TCP_states events :=
sorry

theorem traverse_TCP_states_invalid_error (events : List TCPEvent) (invalid : TCPEvent) :
  ¬(invalid ∈ events) →
  traverse_TCP_states (invalid::events) = TCPState.ERROR :=
sorry
