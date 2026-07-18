import Mathlib

def count [DecidableEq α] : α → List α → Nat
| _x, [] => 0
| x, y::ys => if x == y then 1 + (count x ys) else count x ys


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

theorem prop_BubSortCount (x: Nat) (xs: List Nat) : count x (bubsort xs) == count x xs:= by sorry
