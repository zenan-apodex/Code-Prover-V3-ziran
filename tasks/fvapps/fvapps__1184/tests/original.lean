import Mathlib

structure Request := (movie : Char) (time : String)

def maximize_profit (n : Nat) (requests : List Request) : Int := sorry

theorem profit_is_bounded_above (n : Nat) (requests : List Request) :
  maximize_profit n requests ≤ n * 100 - 100 := sorry

theorem profit_has_lower_bound (n : Nat) (requests : List Request) :
  maximize_profit n requests ≥ -400 := sorry 

theorem empty_requests_profit (requests : List Request) :
  requests = [] → maximize_profit 0 requests = -400 := sorry

theorem single_request_above_min (r : Request) :
  maximize_profit 1 [r] > -400 := sorry 

theorem same_movie_diff_times_above_min (m : Char) :
  let reqs := [⟨m, "3"⟩, ⟨m, "6"⟩, ⟨m, "9"⟩, ⟨m, "12"⟩]
  maximize_profit 4 reqs > -400 := sorry

theorem diff_movies_same_time_above_min (t : String) :
  let reqs := [⟨'A', t⟩, ⟨'B', t⟩, ⟨'C', t⟩, ⟨'D', t⟩] 
  maximize_profit 4 reqs > -400 := sorry
