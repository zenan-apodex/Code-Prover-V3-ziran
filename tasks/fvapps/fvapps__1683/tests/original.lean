import Mathlib

structure GameInput where
  n: Nat
  soldiers: List Nat
  connections: List (Nat × Nat)
  h_n: n ≥ 2
  h_soldiers: soldiers.length = n
  h_valid_conn: ∀ (i j : Nat), (i, j) ∈ connections → i < j ∧ i ≥ 1 ∧ j ≤ n

def solve_game (input : GameInput) : String := sorry

theorem game_result_valid (input : GameInput) : 
  solve_game input = "First" ∨ solve_game input = "Second" := sorry

theorem symmetric_soldiers_same_result (input : GameInput) 
    (h_all_same : ∀ x : Nat, x < input.soldiers.length → input.soldiers[x]! = input.soldiers[0]!)
    (soldiers' : List Nat) 
    (h_len : soldiers'.length = input.n)
    (h_all_same' : ∀ i, i < soldiers'.length → soldiers'[i]! = input.soldiers[0]!) :
    solve_game ⟨input.n, soldiers', input.connections, input.h_n, h_len, input.h_valid_conn⟩ = 
    solve_game input := sorry

theorem zero_soldiers_second (n : Nat) (h : n ≥ 2) :
  let soldiers := List.replicate n 0
  let connections := List.map (fun i => (1, i + 2)) (List.range (n-1))
  solve_game ⟨n, soldiers, connections, h, List.length_replicate n 0, sorry⟩ = "Second" := sorry
