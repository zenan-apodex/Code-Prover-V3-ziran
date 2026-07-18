import Mathlib

def select : List α → List (α × (List α))
  | [] => []
  | x :: xs =>
    ⟨x, xs⟩:: List.map (fun (p: α × (List α))  => (p.1, x::p.2)) (select xs)


def count [DecidableEq α]: α -> List α -> Nat
  | _z, []    => 0
  | z,  x::xs => if x==z then (count z xs).succ else count z xs

theorem prop_SelectPermutations' (xs: List α) (z: α) [DecidableEq α] :
  let n := count z xs
  (List.all
    (List.map
      (fun (p: α × List α) => n == (count z (p.1::p.2)))
      (select xs)
    )
    (fun x => x)
  ):= by sorry
