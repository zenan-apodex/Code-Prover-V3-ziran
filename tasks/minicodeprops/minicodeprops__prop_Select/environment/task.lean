import Mathlib

def select : List α → List (α × (List α))
  | [] => []
  | x :: xs =>
    ⟨x, xs⟩:: List.map (fun (p: α × (List α))  => (p.1, x::p.2)) (select xs)

theorem prop_Select (xs: List α) [DecidableEq α] :
  List.map Prod.fst (select xs) == xs:= by sorry
