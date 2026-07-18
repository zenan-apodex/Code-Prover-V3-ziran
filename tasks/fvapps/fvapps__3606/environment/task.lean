import Mathlib

def findPattern (sequence : List Int) : Option (List Int) := sorry

def differencesSeq (sequence : List Int) : List Int :=
  (sequence.zip (sequence.drop 1)).map (fun (x, y) => y - x)

theorem valid_differences_pattern (sequence : List Int) (h : sequence.length ≥ 2) : 
  match findPattern sequence with
  | none => True 
  | some pattern =>
    let diffs := differencesSeq sequence
    -- Pattern length divides sequence length
    diffs.length % pattern.length = 0 ∧
    -- Pattern matches when repeated
    let repeatedPattern := List.replicate (diffs.length / pattern.length) pattern |>.join
    List.zip diffs repeatedPattern |>.all (fun (a, b) => a = b)
  := sorry

theorem minimal_pattern (sequence : List Int) (h : sequence.length ≥ 2) :
  match findPattern sequence with
  | none => True
  | some pattern =>
    let diffs := differencesSeq sequence
    ∀ i : Nat, 1 ≤ i → i < pattern.length → diffs.length % i = 0 →
      let shortPattern := diffs.take i
      let repeatedShortPattern := List.replicate (diffs.length / i) shortPattern |>.join
      ¬(List.zip diffs repeatedShortPattern |>.all (fun (a, b) => a = b))
  := sorry

theorem arithmetic_sequence_pattern (d : Int) (len : Nat) (h₁ : 1 ≤ d ∧ d ≤ 9) (h₂ : 2 ≤ len ∧ len ≤ 100) :
  let arithmetic := List.range len |>.map (fun n => Int.ofNat n * d)
  match findPattern arithmetic with
  | none => False
  | some pattern =>
    pattern.length = 1 ∧ pattern.head! = d
  := sorry
