import Mathlib

def encode (n : Nat) (s : String) : String := sorry
def decode (s : String) : String := sorry

/- For any number n and text, decoding after encoding returns original text -/
theorem encode_decode_roundtrip (n : Nat) (text : String) :
  decode (encode n text) = text := sorry 

/- The first word of encoded text equals the input number n as string -/  
theorem encode_starts_with_n (n : Nat) (text : String) : 
  List.get! (String.splitOn (encode n text) " ") 0 = toString n := sorry

/- Empty string cases -/
theorem empty_string_case1 : decode (encode 5 "") = "" := sorry
theorem empty_string_case2 : encode 0 "" = "0 " := sorry
