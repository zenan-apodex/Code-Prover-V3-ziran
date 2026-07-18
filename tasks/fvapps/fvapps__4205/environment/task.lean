import Mathlib

abbrev Response := String
abbrev Gunner := String

structure HashMap (α β : Type) where
  dummy : Unit

def HashMap.toArray {α β : Type} : HashMap α β → Array (α × β) :=
  fun _ => #[]

def isAye : String → Bool
| "aye" => true
| _ => false

def cannons_ready (gunners : HashMap Gunner Response) : String :=
sorry

theorem cannons_ready_all_conditions {gunners : HashMap Gunner Response} :
  cannons_ready gunners = if (gunners.toArray.all (fun p => isAye p.2))
    then "Fire!"
    else "Shiver me timbers!"
  := sorry

theorem cannons_ready_all_aye {gunners : HashMap Gunner Response} :
  (gunners.toArray.all (fun p => isAye p.2)) →
  cannons_ready gunners = "Fire!"
  := sorry

theorem cannons_ready_all_nay {gunners : HashMap Gunner Response} :
  (gunners.toArray.all (fun p => ¬isAye p.2)) →
  cannons_ready gunners = "Shiver me timbers!"
  := sorry
