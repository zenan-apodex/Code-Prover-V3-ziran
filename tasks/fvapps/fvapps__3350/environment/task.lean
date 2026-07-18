import Mathlib

structure RGB where
  r : Nat
  g : Nat 
  b : Nat
  r_valid : r ≤ 255
  g_valid : g ≤ 255
  b_valid : b ≤ 255
deriving Repr

def hexStringToRGB (s : String) : Option RGB := sorry

theorem hex_string_to_RGB_valid {r g b : Nat} 
  (hr : r ≤ 255) (hg : g ≤ 255) (hb : b ≤ 255) :
  ∀ (hex : String),
  match hexStringToRGB hex with
  | none => True
  | some rgb => 
    rgb.r ≤ 255 ∧ 
    rgb.g ≤ 255 ∧ 
    rgb.b ≤ 255 := sorry

theorem hex_string_to_RGB_correct {r g b : Nat}
  (hr : r ≤ 255) (hg : g ≤ 255) (hb : b ≤ 255) :
  ∀ (hex : String),
  match hexStringToRGB hex with
  | none => True
  | some rgb =>
    rgb.r = r ∧
    rgb.g = g ∧
    rgb.b = b := sorry
