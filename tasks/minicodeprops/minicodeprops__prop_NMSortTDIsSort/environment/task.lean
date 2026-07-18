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


def half : Nat → Nat
| 0 => 0
| 1 => 0
| x + 2 => 1 + (half x)


lemma half_lt: half x ≤ x := by
  induction x using Nat.strong_induction_on with
  | h n ih =>
    cases n with
    | zero => unfold half; simp;
    | succ nm1 =>
      cases nm1 with
      | zero => unfold half; simp;
      | succ nm2 =>
        unfold half;
        have tmp := ih nm2 (by exact Nat.le.step Nat.le.refl);
        ring_nf;
        calc 1 + half nm2 ≤ 1 + nm2  := Nat.add_le_add (@Nat.le.refl 1) tmp
             _           ≤  2 + nm2  := by simp


def nmsorttd : List Nat → List Nat
| [] => []
| [x] => [x]
| x::y::xs =>
  let k:= half ((x::y::xs).length)
  have _h: half (Nat.succ (Nat.succ (List.length xs))) < Nat.succ (Nat.succ (List.length xs)) := by
    rw [Nat.succ_eq_add_one _];
    ring_nf;
    rw [Nat.add_comm];
    unfold half;
    ring_nf;
    calc 1 + half (xs.length) ≤ 1 + xs.length := by simp; exact half_lt;
         _               < 2 + xs.length := by simp;
  have _h': Nat.succ (Nat.succ (List.length xs)) - half (Nat.succ (Nat.succ (List.length xs))) <
  Nat.succ (Nat.succ (List.length xs)) := by
    suffices h': 0 < half (Nat.succ (Nat.succ (List.length xs)))
    case h';
      unfold half;simp;
    refine Nat.sub_lt ?h h'
    simp;
  lmerge (nmsorttd ((x::y::xs).take k)) (nmsorttd ((x::y::xs).drop k))
termination_by xs => xs.length

theorem prop_NMSortTDIsSort (xs: List Nat) : nmsorttd xs == isort xs:= by sorry
