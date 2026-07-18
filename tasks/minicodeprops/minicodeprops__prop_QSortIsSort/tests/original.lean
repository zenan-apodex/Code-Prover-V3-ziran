import Mathlib

def insert' : Nat → List Nat → List Nat
| x, [] => [x]
| x, y::xs => if x <= y then x::y::xs else y::(insert x xs)


def isort: List Nat → List Nat
| [] => []
| x::xs => insert' x (isort xs)


def filter : List Nat → (Nat → Bool) → List Nat
| [], _f => []
| x::xs, f => if f x then x::(filter xs f) else (filter xs f)


lemma filter_len_le {f: Nat → Bool} {xs: List Nat}: (filter xs f).length <= xs.length := by
  generalize hxsl: xs.length = xsl
  induction xsl generalizing xs with
  | zero => rw [List.length_eq_zero] at hxsl; rw [hxsl]; unfold filter; simp;
  | succ n ih =>
    cases xs with
    | nil => unfold filter; simp;
    | cons head tail =>
      rw [List.length_cons] at hxsl; simp at hxsl;
      unfold filter; split_ifs with h1;
      case pos;
        rw [List.length_cons];
        exact Nat.pred_le_iff.mp (ih hxsl)
      case neg;
        exact Nat.le.step (ih hxsl)


lemma qsort_term (x:Nat) (xs: List Nat) : List.length (filter xs fun y => decide (y ≤ x)) < Nat.succ (List.length xs) := by
  exact Nat.lt_succ_of_le (filter_len_le);


lemma qsort_term2 (x:Nat) (xs: List Nat) : List.length (filter xs fun y => decide (y > x)) < Nat.succ (List.length xs) := by
  exact Nat.lt_succ_of_le (filter_len_le);


def qsort : List Nat → List Nat
| [] => []
| x::xs =>
  have _h:= qsort_term x xs
  have _h2:= qsort_term2 x xs
  (qsort (filter xs (fun y => y <= x))) ++ [x] ++ (qsort (filter xs (fun y => y > x)))
termination_by xs => xs.length

theorem prop_QSortIsSort (xs: List Nat) : qsort xs == isort xs:= by sorry
