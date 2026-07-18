import Mathlib

inductive Direction where
  | N : Direction
  | S : Direction
  | E : Direction
  | W : Direction
deriving DecidableEq

def Direction.toString : Direction → String
  | Direction.N => "N"
  | Direction.S => "S"
  | Direction.E => "E"
  | Direction.W => "W"

def Path := List Direction

def directions (p : Path) : Path :=
  sorry

theorem directions_preserves_endpoint (p : Path) :
  let result := directions p
  let orig_ns := (p.filter (· = Direction.N)).length - (p.filter (· = Direction.S)).length
  let orig_ew := (p.filter (· = Direction.E)).length - (p.filter (· = Direction.W)).length
  let result_ns := (result.filter (· = Direction.N)).length - (result.filter (· = Direction.S)).length  
  let result_ew := (result.filter (· = Direction.E)).length - (result.filter (· = Direction.W)).length
  orig_ns = result_ns ∧ orig_ew = result_ew :=
sorry

theorem directions_ordering (p : Path) : 
  let result := directions p
  let result_str := String.join (result.map Direction.toString)
  ¬(result_str.any (fun cs => cs.toString = "SN")) ∧ 
  ¬(result_str.any (fun cs => cs.toString = "WE")) := 
sorry

theorem directions_empty_at_origin (p : Path) :
  let ns_movement := (p.filter (· = Direction.N)).length - (p.filter (· = Direction.S)).length
  let ew_movement := (p.filter (· = Direction.E)).length - (p.filter (· = Direction.W)).length
  ns_movement = 0 ∧ ew_movement = 0 → directions p = [] :=
sorry

theorem directions_output_types (p : Path) :
  let result := directions p
  result.all (fun x => match x with
    | Direction.N => true
    | Direction.S => true
    | Direction.E => true
    | Direction.W => true) :=
sorry
