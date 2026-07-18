import Mathlib

def select : List α → List (α × (List α))
  | [] => []
  | x :: xs =>
    ⟨x, xs⟩:: List.map (fun (p: α × (List α))  => (p.1, x::p.2)) (select xs)


def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)


def isPermutation [DecidableEq α] : List α → List α → Bool
| [], ys => (ys == [])
| x::xs, ys => x ∈ ys && (isPermutation xs (deleteFirst x ys))

theorem prop_SelectPermutations (xs: List α) [DecidableEq α] :
  (List.all
    (List.map
      (fun (p: α × List α) => isPermutation xs (p.1::p.2))
      (select xs)
    )
    (fun x => x)
  ):= by sorry
