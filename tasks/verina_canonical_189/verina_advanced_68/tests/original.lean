-- !benchmark @start import type=solution
import Mathlib
-- !benchmark @end import

-- !benchmark @start solution_aux

-- !benchmark @end solution_aux

-- !benchmark @start precond_aux

-- !benchmark @end precond_aux
@[reducible]
def runLengthEncoder_precond (input : String) : Prop :=
  -- !benchmark @start precond
  input.all (fun c => ¬c.isDigit)  -- no digits allowed in input (ambiguous encoding)
  -- !benchmark @end precond


-- !benchmark @start code_aux

-- !benchmark @end code_aux


def runLengthEncoder (input : String) (h_precond : runLengthEncoder_precond (input)) : String :=
  -- !benchmark @start code
  sorry
  -- !benchmark @end code

-- !benchmark @start postcond_aux

-- !benchmark @end postcond_aux


@[reducible]
def runLengthEncoder_postcond (input : String) (result: String) (h_precond : runLengthEncoder_precond (input)) : Prop :=
  -- !benchmark @start postcond
  -- Helper functions
  let chars : String → List Char := fun s => s.data

  -- Parse encoded string into (char, count) pairs
  let parseEncodedString : String → List (Char × Nat) :=
    let rec parseState : List Char → Option Char → Option Nat → List (Char × Nat) → List (Char × Nat) :=
      fun remaining currentChar currentCount acc =>
        match remaining with
        | [] =>
          -- Add final pair if we have both char and count
          match currentChar, currentCount with
          | some c, some n => (c, n) :: acc
          | _, _ => acc
        | c :: cs =>
          if c.isDigit then
            match currentChar with
            | none => [] -- Invalid format: digit without preceding character
            | some ch =>
              -- Update current count
              let digit := c.toNat - 48
              let newCount :=
                match currentCount with
                | none => digit
                | some n => n * 10 + digit
              parseState cs currentChar (some newCount) acc
          else
            -- We found a new character, save previous pair if exists
            let newAcc :=
              match currentChar, currentCount with
              | some ch, some n => (ch, n) :: acc
              | _, _ => acc
            parseState cs (some c) none newAcc

    fun s =>
      let result := parseState (chars s) none none []
      result.reverse

  -- Format check: characters followed by at least one digit
  let formatValid : Bool :=
    let rec checkPairs (chars : List Char) (nowDigit : Bool) : Bool :=
      match chars with
      | [] => true
      | c :: cs =>
        if nowDigit && c.isDigit then
          checkPairs cs true
        else
        -- Need at least one digit after character
          match cs with
          | [] => false -- Ending with character, no digits
          | d :: ds =>
            if d.isDigit then
              checkPairs ds true
            else
              false -- No digit after character

    checkPairs (chars result) false

  -- Content validation
  let contentValid : Bool :=
    let pairs := parseEncodedString result
    let expanded := pairs.flatMap (fun (c, n) => List.replicate n c)
    expanded == chars input

  -- Empty check
  let nonEmptyValid : Bool :=
    input.isEmpty = result.isEmpty

  formatValid && contentValid && nonEmptyValid
  -- !benchmark @end postcond

-- !benchmark @start proof_aux

-- !benchmark @end proof_aux


theorem runLengthEncoder_spec_satisfied (input: String) (h_precond : runLengthEncoder_precond (input)) :
    runLengthEncoder_postcond (input) (runLengthEncoder (input) h_precond) h_precond := by
  -- !benchmark @start proof
  sorry
  -- !benchmark @end proof


