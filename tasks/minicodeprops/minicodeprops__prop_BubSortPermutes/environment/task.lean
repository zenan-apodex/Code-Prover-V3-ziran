import Mathlib

def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)


def isPermutation [DecidableEq α] : List α → List α → Bool
| [], ys => (ys == [])
| x::xs, ys => x ∈ ys && (isPermutation xs (deleteFirst x ys))


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

theorem prop_BubSortPermutes (xs: List Nat) : isPermutation (bubsort xs) xs == true:= by sorry
