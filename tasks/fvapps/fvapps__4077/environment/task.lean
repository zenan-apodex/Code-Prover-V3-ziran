import Mathlib

structure TeamMap where
  teams : List (String × String)
  nodup : (teams.map Prod.fst).Nodup

def premier_league_standings (teams : TeamMap) : TeamMap := sorry

theorem first_place_always_present (teams : TeamMap) 
  (h : teams.teams.any (fun p => p.1 = "1")) :
  let result := premier_league_standings teams
  result.teams.any (fun p => p.1 = "1") ∧
  (result.teams.find? (fun p => p.1 = "1")).map Prod.snd = 
  (teams.teams.find? (fun p => p.1 = "1")).map Prod.snd := sorry

theorem result_is_sorted (teams : TeamMap)
  (h1 : teams.teams.any (fun p => p.1 = "1"))
  (h2 : teams.teams.length ≥ 2) :
  let result := premier_league_standings teams
  let first_team := (teams.teams.find? (fun p => p.1 = "1")).map Prod.snd
  let rest_teams := (teams.teams.map Prod.snd).filter (fun x => 
    match first_team with
    | none => true
    | some ft => x ≠ ft)
  result.teams.head?.map Prod.snd = first_team ∧ 
  match result.teams.tail with
  | [] => true
  | xs => ∀ i j, i < j → j < xs.length → 
         (xs.get ⟨i, sorry⟩).2 ≤ (xs.get ⟨j, sorry⟩).2 := sorry

theorem keys_are_sequential (teams : TeamMap)
  (h : teams.teams.any (fun p => p.1 = "1")) :
  let result := premier_league_standings teams
  ∀ i, i < result.teams.length → 
  result.teams.any (fun p => p.1 = toString (i + 1)) := sorry

theorem no_duplicate_teams (teams : TeamMap)
  (h : teams.teams.any (fun p => p.1 = "1")) :
  let result := premier_league_standings teams
  (result.teams.map Prod.snd).Nodup := sorry
