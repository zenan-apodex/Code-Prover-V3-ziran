import Mathlib

inductive Step where
  | Up : Step
  | Down : Step
deriving Inhabited, DecidableEq

def countValleys (path: List Step) : Nat := sorry

theorem valley_count_nonnegative (path : List Step) :
  countValleys path ≥ 0 := sorry

theorem valley_count_bounded_by_down_steps (path : List Step) 
  (h: (path.filter (· = Step.Up)).length = (path.filter (· = Step.Down)).length) :
  countValleys path ≤ (path.filter (· = Step.Down)).length := sorry

theorem single_step_no_valley (s : Step) :
  countValleys [s] = 0 := sorry

theorem valley_count_simple_segments (segments : List (Step × Step))
  (h: ∀ p ∈ segments, p.1 = Step.Down ∧ p.2 = Step.Up) :
  countValleys (segments.bind (fun p => [p.1, p.2])) = segments.length := sorry

theorem upward_path_no_valleys (path : List Step)
  (h: ∀ s ∈ path, s = Step.Up) :
  countValleys path = 0 := sorry
