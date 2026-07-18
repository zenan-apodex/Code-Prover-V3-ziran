import Mathlib

def cookieStorageStr (num : Nat) (types : List Nat) : String := sorry

def determineWinner (n : Nat) (storages : List String) : String := sorry

structure ScoreData where
  score: Nat
  uniqueTypes: Nat

def calculateScore (cookies : List Nat) : Nat :=
  let score := cookies.head!
  let types := cookies.tail!.eraseDups
  let numTypes := types.length
  match numTypes with
  | n => if n ≥ 6 then score + 4
         else if n ≥ 5 then score + 2
         else if n ≥ 4 then score + 1
         else score

theorem winner_validity (n : Nat) (storages : List String) :
  let result := determineWinner n storages
  (result = "tie" ∨ result = "chef" ∨ result.toNat? ≠ none) ∧ 
  (result.toNat?.isSome → 1 ≤ result.toNat! ∧ result.toNat! ≤ n) := sorry

theorem winner_has_highest_score (n : Nat) (storages : List String) :
  let result := determineWinner n storages
  let scores := storages.map (λ s => 
    let cookies := (s.split (· = ' ')).map String.toNat!
    calculateScore cookies)
  let maxScore := scores.maximum?
  match result with 
  | "tie" => maxScore.isSome ∧ (scores.filter (· = maxScore!)).length ≥ 2 
  | "chef" => maxScore.isSome ∧ scores.head! = maxScore! ∧ 
              (scores.filter (· = maxScore!)).length = 1
  | _ => maxScore.isSome ∧ 
         scores[result.toNat! - 1]! = maxScore! ∧
         (scores.filter (· = maxScore!)).length = 1 := sorry
