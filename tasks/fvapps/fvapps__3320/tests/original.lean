import Mathlib

inductive CoinFlip where
  | H : CoinFlip
  | T : CoinFlip
deriving Inhabited, DecidableEq

inductive LineName where
  | One : LineName
  | Two : LineName  
  | Three : LineName
  | Four : LineName
  | Five : LineName
  | Six : LineName
deriving Inhabited, DecidableEq

inductive LineOutput where
  | Circle : LineOutput 
  | X : LineOutput
  | Space : LineOutput
  | Empty : LineOutput
deriving Inhabited, DecidableEq

def oracle (input : List (LineName × CoinFlip × CoinFlip × CoinFlip)) : List LineOutput :=
  sorry

def getOutput (output : List LineOutput) (line : LineName × CoinFlip × CoinFlip × CoinFlip) : LineOutput :=
  sorry

def sortFlips (f1 f2 f3 : CoinFlip) : CoinFlip × CoinFlip × CoinFlip :=
  sorry

theorem oracle_output_length {input : List (LineName × CoinFlip × CoinFlip × CoinFlip)} 
  (h1 : input.length = 6)
  (h2 : ∀ x y, x ∈ input → y ∈ input → x.1 = y.1 → x = y) :
  (oracle input).length = 6 := 
  sorry

theorem line_positions_valid {input : List (LineName × CoinFlip × CoinFlip × CoinFlip)}
  (h1 : input.length = 6)
  (h2 : ∀ x y, x ∈ input → y ∈ input → x.1 = y.1 → x = y) :
  ∀ line, line ∈ input → ∃ pos, pos < 6 :=
  sorry

theorem oracle_flip_mapping {input : List (LineName × CoinFlip × CoinFlip × CoinFlip)}
  (h1 : input.length = 6)
  (h2 : ∀ x y, x ∈ input → y ∈ input → x.1 = y.1 → x = y)
  (line : LineName × CoinFlip × CoinFlip × CoinFlip) 
  (h3 : line ∈ input) :
  let (name, f1, f2, f3) := line
  let (s1, s2, s3) := sortFlips f1 f2 f3
  if s1 = CoinFlip.H ∧ s2 = CoinFlip.H ∧ s3 = CoinFlip.H then
    getOutput (oracle input) line = LineOutput.Circle
  else if s1 = CoinFlip.T ∧ s2 = CoinFlip.T ∧ s3 = CoinFlip.T then
    getOutput (oracle input) line = LineOutput.X
  else if s1 = CoinFlip.H ∧ s2 = CoinFlip.H ∧ s3 = CoinFlip.T then
    getOutput (oracle input) line = LineOutput.Space
  else if s1 = CoinFlip.H ∧ s2 = CoinFlip.T ∧ s3 = CoinFlip.T then
    getOutput (oracle input) line = LineOutput.Empty
  else
    True :=
  sorry
