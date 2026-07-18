import Mathlib

inductive Frame where
  | mk : Int → Frame

instance : Inhabited Frame where
  default := Frame.mk 1

def DNA := String
def Protein := String

instance : Inhabited Protein where
  default := ""

def validate_frame (f : Frame) : Bool :=
  match f with
  | Frame.mk n => n ≠ 0

def translate_with_frame : DNA → List Frame → List Protein := sorry
def isValidAminoAcid (c : Char) : Bool := sorry

theorem translate_length_matches_frames (dna : DNA) (frames : List Frame) :
  frames.all validate_frame →
  (translate_with_frame dna frames).length = frames.length := sorry

theorem translate_produces_valid_strings (dna : DNA) (frames : List Frame) :
  frames.all validate_frame →
  (translate_with_frame dna frames).all (fun x => true) := sorry

theorem empty_dna_gives_empty_proteins (frames : List Frame) :
  frames.all validate_frame →
  (translate_with_frame "" frames).all String.isEmpty := sorry

theorem valid_amino_acids_only (dna : DNA) (frames : List Frame) :
  frames.all validate_frame →
  (translate_with_frame dna frames).all (fun protein => 
    protein.data.all isValidAminoAcid) := sorry

def default_frames : List Frame := 
  [Frame.mk 1, Frame.mk 2, Frame.mk 3, Frame.mk (-1), Frame.mk (-2), Frame.mk (-3)]

theorem default_frames_gives_six (dna : DNA) :
  (translate_with_frame dna default_frames).length = 6 := sorry

theorem complementary_frames_equal_length (dna : DNA) :
  dna.length ≥ 3 →
  let result := translate_with_frame dna [Frame.mk 1, Frame.mk (-1)]
  result[0]!.length = result[1]!.length := sorry
