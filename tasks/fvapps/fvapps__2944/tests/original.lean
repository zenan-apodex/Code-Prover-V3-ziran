import Mathlib

inductive Element
| H | He | Li | Be | B | C | N | O | F | Ne | Na | Mg | Al | Si | P | S | Cl | Ar 
| K | Ca | Sc | Ti | V | Cr | Mn | Fe | Co | Ni | Cu | Zn | Ga | Ge | As | Se 
| Br | Kr | Rb | Sr | Y | Zr | Nb | Mo | Tc | Ru | Rh | Pd | Ag | Cd | In | Sn 
| Sb | Te | I | Xe | Cs | Ba | La | Ce | Pr | Nd | Pm | Sm | Eu | Gd | Tb | Dy 
| Ho | Er | Tm | Yb | Lu | Hf | Ta | W | Re | Os | Ir | Pt | Au | Hg | Tl | Pb 
| Bi | Po | At | Rn | Fr | Ra | Ac | Th | Pa | U | Np | Pu | Am | Cm | Bk | Cf 
| Es | Fm | Md | No | Lr | Rf | Db | Sg | Bh | Hs | Mt | Ds | Rg | Cn | Nh | Fl 
| Mc | Lv | Ts | Og
deriving Repr

def Element.toNat : Element → Nat 
| H => 1 | He => 2 | Li => 3 | Be => 4 | B => 5 | C => 6 | N => 7 | O => 8
| F => 9 | Ne => 10 | Na => 11 | Mg => 12 | Al => 13 | Si => 14 | P => 15
| S => 16 | Cl => 17 | Ar => 18 | K => 19 | Ca => 20 | Sc => 21 | Ti => 22
| V => 23 | Cr => 24 | Mn => 25 | Fe => 26 | Co => 27 | Ni => 28 | Cu => 29
| Zn => 30 | Ga => 31 | Ge => 32 | As => 33 | Se => 34 | Br => 35 | Kr => 36
| Rb => 37 | Sr => 38 | Y => 39 | Zr => 40 | Nb => 41 | Mo => 42 | Tc => 43
| Ru => 44 | Rh => 45 | Pd => 46 | Ag => 47 | Cd => 48 | In => 49 | Sn => 50
| Sb => 51 | Te => 52 | I => 53 | Xe => 54 | Cs => 55 | Ba => 56 | La => 57
| Ce => 58 | Pr => 59 | Nd => 60 | Pm => 61 | Sm => 62 | Eu => 63 | Gd => 64
| Tb => 65 | Dy => 66 | Ho => 67 | Er => 68 | Tm => 69 | Yb => 70 | Lu => 71
| Hf => 72 | Ta => 73 | W => 74 | Re => 75 | Os => 76 | Ir => 77 | Pt => 78
| Au => 79 | Hg => 80 | Tl => 81 | Pb => 82 | Bi => 83 | Po => 84 | At => 85
| Rn => 86 | Fr => 87 | Ra => 88 | Ac => 89 | Th => 90 | Pa => 91 | U => 92
| Np => 93 | Pu => 94 | Am => 95 | Cm => 96 | Bk => 97 | Cf => 98 | Es => 99
| Fm => 100 | Md => 101 | No => 102 | Lr => 103 | Rf => 104 | Db => 105
| Sg => 106 | Bh => 107 | Hs => 108 | Mt => 109 | Ds => 110 | Rg => 111
| Cn => 112 | Nh => 113 | Fl => 114 | Mc => 115 | Lv => 116 | Ts => 117
| Og => 118

inductive Orbital 
| s | p | d | f | g
deriving Repr

structure OrbitalConfig where
  n: Nat 
  l: Orbital
  electrons: Nat

def get_electron_configuration (e: Element) : List OrbitalConfig :=
  sorry

theorem electron_config_format (e: Element) (config: List OrbitalConfig):
  get_electron_configuration e = config →
  ∀ oc ∈ config, 
    oc.n > 0 ∧ 
    match oc.l with
    | Orbital.s => oc.electrons ≤ 2
    | Orbital.p => oc.electrons ≤ 6
    | Orbital.d => oc.electrons ≤ 10  
    | Orbital.f => oc.electrons ≤ 14
    | Orbital.g => oc.electrons ≤ 18
:= sorry

def sumElectrons (config: List OrbitalConfig) : Nat :=
  match config with
  | [] => 0
  | x :: xs => x.electrons + sumElectrons xs

theorem electron_count_conservation (e: Element):
  let config := get_electron_configuration e
  sumElectrons config = Element.toNat e := sorry

theorem orbital_order (e: Element):
  let config := get_electron_configuration e
  ∀ i j, i ≤ j → i < config.length → j < config.length →
  (config.get ⟨i, sorry⟩).n ≤ (config.get ⟨j, sorry⟩).n := sorry

theorem first_period (e: Element) :
  (e = Element.H ∨ e = Element.He) →
  let config := get_electron_configuration e
  ∀ oc ∈ config, oc.n = 1 ∧ oc.l = Orbital.s := sorry
