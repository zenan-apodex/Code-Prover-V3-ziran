import Mathlib

def insert' : Nat → List Nat → List Nat
| x, [] => [x]
| x, y::xs => if x <= y then x::y::xs else y::(insert x xs)


def isort: List Nat → List Nat
| [] => []
| x::xs => insert' x (isort xs)


def bubsort (xs : List Nat) : {l' : List Nat // xs.length = l'.length} :=
  match xs with
  | [] => ⟨[], rfl⟩
  | x :: xs =>
    match bubsort xs with
    | ⟨[], h⟩ => ⟨[x], by simp[h]⟩
    | ⟨y :: ys, h⟩ =>
      if y < x then
        have : Nat.succ (List.length ys) < Nat.succ (List.length xs) := by rw [h, List.length_cons]; apply Nat.lt_succ_self
        let ⟨zs, he⟩ := bubsort (x :: ys)
        ⟨y :: zs, by simp[h, ← he]⟩
      else
        ⟨x :: y :: ys, by simp[h]⟩
termination_by xs.length


def bubblesort (xs: List Nat) : List Nat :=
  bubsort xs

theorem prop_BubSortIsSort (xs: List Nat) : bubblesort xs == isort xs:= by sorry
