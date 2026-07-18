import Mathlib

structure PlayType where
  val : String
  deriving BEq

def Play := Int × PlayType
def PlayList := List Play

def turnover : PlayType := ⟨"turnover"⟩
def pass : PlayType := ⟨"pass"⟩
def sack : PlayType := ⟨"sack"⟩

def did_we_win (plays : PlayList) : Bool := 
  sorry

theorem did_we_win_properties (plays : PlayList) : 
  let filtered := plays.filter (fun p => true)
  let hasNoTurnovers := ¬(filtered.any (fun p => p.2 == turnover))
  let total := filtered.foldl (fun acc p => 
    acc + (if p.2 == sack then -p.1 else p.1)) 0

  did_we_win plays → (hasNoTurnovers ∧ total > 10) ∧ 
  (¬(did_we_win plays) → (¬hasNoTurnovers ∨ total ≤ 10)) :=
  sorry

theorem winning_plays (plays : PlayList) :
  plays.all (fun p => p.1 ≥ 11 && p.2 == pass) ∧ plays.length > 0 →
  did_we_win plays :=
  sorry

theorem losing_plays_yardage (plays : PlayList) :
  plays.all (fun p => p.1 ≤ 10 && p.2 == pass) ∧ plays.length > 0 →
  ¬(did_we_win plays) :=
  sorry

theorem losing_plays_turnover (plays : PlayList) :
  plays.all (fun p => p.2 == turnover) ∧ plays.length > 0 →
  ¬(did_we_win plays) :=
  sorry
