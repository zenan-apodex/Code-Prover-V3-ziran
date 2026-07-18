import Mathlib

def count [DecidableEq α] : α → List α → Nat
| _x, [] => 0
| x, y::ys => if x == y then 1 + (count x ys) else count x ys


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

theorem prop_QSortCount (x: Nat) (xs: List Nat) : count x (qsort xs) == count x xs:= by sorry
