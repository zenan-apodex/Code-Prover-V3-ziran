import Mathlib

def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)


def isPermutation [DecidableEq α] : List α → List α → Bool
| [], ys => (ys == [])
| x::xs, ys => x ∈ ys && (isPermutation xs (deleteFirst x ys))


def lmerge : List Nat → List Nat → List Nat
| [], ys => ys
| xs, [] => xs
| x::xs, y::ys => if  x <= y  then
      x::(lmerge xs (y::ys))
    else
      y::(lmerge (x::xs) ys)


def msorttd : List Nat → List Nat
| [] => []
| [x] => [x]
| x::y::xs =>
  let k:= (x::y::xs).length/2
  have _h: Nat.succ (Nat.succ (List.length xs)) / 2 < Nat.succ (Nat.succ (List.length xs)) := by
    rw [Nat.succ_eq_add_one _];
    ring_nf;
    simp [Nat.succ_eq_add_one _];
    ring_nf;
    calc 1 + xs.length/2 ≤ 1 + xs.length := by simp; exact Nat.div_le_self (List.length xs) 2;
         _               < 2 + xs.length := by simp;
  lmerge (msorttd ((x::y::xs).take k)) (msorttd ((x::y::xs).drop k))
termination_by xs => xs.length

theorem prop_MSortTDPermutes (xs: List Nat) : isPermutation (msorttd xs) xs == true:= by sorry
