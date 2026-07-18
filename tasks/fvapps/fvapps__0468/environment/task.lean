import Mathlib

structure DecimalRepr where
  value: String
  isValid: Bool

def toFloat (s: String) : Float :=
  sorry

def intToFloat (n: Int) : Float :=
  sorry

def fraction_to_decimal (n: Int) (d: Int) : DecimalRepr :=
  sorry

theorem positive_fraction_valid_format (n d: Int)
  (hn: 0 < n) (hd: 0 < d) (hdn: n ≤ 10^6 ∧ d ≤ 10^6) :
  (fraction_to_decimal n d).isValid = true :=
  sorry

theorem positive_fraction_matches_value (n d: Int)
  (hn: 0 < n) (hd: 0 < d) (hdn: n ≤ 10^6 ∧ d ≤ 10^6) :
  (((toFloat (fraction_to_decimal n d).value) - ((intToFloat n) / (intToFloat d))).abs < 1e-10) :=
  sorry

theorem whole_numbers_no_decimals (n: Int)
  (hn: -10^6 ≤ n ∧ n ≤ 10^6) (hnz: n ≠ 0) :
  let res := (fraction_to_decimal n 1).value
  ¬res.contains '.' ∧ ¬res.contains '(' ∧ res.toInt! = n :=
  sorry

theorem zero_numerator (d: Int)
  (hd: 0 < d) (hdb: d ≤ 10^6) :
  (fraction_to_decimal 0 d).value = "0" :=
  sorry
