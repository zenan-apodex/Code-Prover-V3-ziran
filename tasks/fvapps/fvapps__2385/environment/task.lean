import Mathlib

def List.sum (xs : List Nat) : Nat :=
  xs.foldl (· + ·) 0

def find_max_robots_and_black_cells (n m : Nat) (colors directions : List String) : Nat × Nat := sorry

theorem output_types_and_ranges {n m : Nat} {colors directions : List String}
  (h : n > 0 ∧ m > 0)
  (hlen : colors.length = n ∧ directions.length = n)
  (hcolors : ∀ row ∈ colors, row.length = m ∧ (∀ c ∈ String.toList row, c = '0' ∨ c = '1'))
  (hdirs : ∀ row ∈ directions, row.length = m ∧ (∀ d ∈ String.toList row, d = 'U' ∨ d = 'D' ∨ d = 'R' ∨ d = 'L')) :
  let (robots, black_cells) := find_max_robots_and_black_cells n m colors directions;
  robots ≥ 0 ∧ 
  black_cells ≥ 0 ∧
  black_cells ≤ robots ∧
  black_cells ≤ (List.map (λ row => List.length (List.filter (λ x => x = '0') (String.toList row))) colors).sum := sorry
