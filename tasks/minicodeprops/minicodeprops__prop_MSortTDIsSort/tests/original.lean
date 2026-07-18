import Mathlib

def insert' : Nat → List Nat → List Nat
| x, [] => [x]
| x, y::xs => if x <= y then x::y::xs else y::(insert x xs)


def isort: List Nat → List Nat
| [] => []
| x::xs => insert' x (isort xs)


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

theorem prop_MSortTDIsSort (xs: List Nat) : msorttd xs == isort xs:= by sorry
