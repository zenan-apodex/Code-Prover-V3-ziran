import Mathlib

def insert' : Nat → List Nat → List Nat
| x, [] => [x]
| x, y::xs => if x <= y then x::y::xs else y::(insert x xs)


def isort: List Nat → List Nat
| [] => []
| x::xs => insert' x (isort xs)


def risers : List Nat → List (List Nat)
| [] => []
| [x] => [[x]]
| x::y::xs => if x <= y then
      match (risers (y::xs)) with
      | ys::yss => (x::ys)::yss
      | _ => []
    else
      [x]::(risers (y::xs))


def lmerge : List Nat → List Nat → List Nat
| [], ys => ys
| xs, [] => xs
| x::xs, y::ys => if  x <= y  then
      x::(lmerge xs (y::ys))
    else
      y::(lmerge (x::xs) ys)


def pairwise : List (List Nat) → List (List Nat)
| xs::ys::xss => lmerge xs ys :: pairwise xss
| xss => xss


lemma len_pairwise (xs: List (List Nat)): 2 * (pairwise xs).length = (if (Odd xs.length) then xs.length + 1 else xs.length) := by
  generalize hxl : xs.length = xl;
  split_ifs with h1;
  case pos;
    induction xl using Nat.strong_induction_on generalizing xs with
    | h xls ih =>
        rw [← hxl] at h1;
        cases xs with
        | nil => simp at h1;
        | cons head2 tail2 =>
          cases tail2 with
          | nil => unfold pairwise; simp at hxl; rw [←hxl]; simp;
          | cons head3 tail3 =>
            unfold pairwise;
            rw [←hxl, List.length_cons, List.length_cons, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _]
            ring_nf;
            simp;
            have hodd: Odd tail3.length := by
              rw [List.length_cons, List.length_cons, Nat.succ_eq_add_one _, Nat.add_assoc, Nat.odd_add] at h1;
              apply h1.2; simp;
            have tmp := ih tail3.length (by rw [←hxl]; simp; linarith;) tail3 rfl hodd
            ring_nf at tmp;
            rw [tmp];
            ring_nf;
  case neg;
    induction xl using Nat.strong_induction_on generalizing xs with
    | h xls ih =>
        rw [← hxl] at h1;
        cases xs with
        | nil => unfold pairwise; simp [← hxl]
        | cons head2 tail2 =>
          cases tail2 with
          | nil => simp at h1;
          | cons head3 tail3 =>
            unfold pairwise;
            rw [←hxl, List.length_cons, List.length_cons, List.length_cons, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _];
            ring_nf;
            simp;
            simp at h1;
            have heven: Even tail3.length := by
              rw [Nat.add_assoc, Nat.even_add] at h1;
              apply h1.2; simp;
            simp at ih;
            have tmp := ih tail3.length (by rw [←hxl]; simp; linarith;) tail3 rfl heven
            ring_nf at tmp;
            exact tmp;


def mergingbu2 : List (List Nat) → List Nat
| [] => []
| [xs] => xs
| xs::ys::xss =>
  have _h: (pairwise (xs::ys::xss)).length < (xs::ys::xss).length := by
    suffices h': 2* List.length (pairwise (xs :: ys :: xss)) < 2 * List.length (xs :: ys :: xss)
    case h';
      rw [ len_pairwise _];
      split_ifs with hparity;
      case pos;
        simp;
        ring_nf;
        linarith;
      case neg;
        simp;
    linarith [h'];
  mergingbu2 (pairwise (xs::ys::xss))
termination_by xss => xss.length


def msortbu2 : List Nat → List Nat
| xs => mergingbu2 (risers xs)

theorem prop_MSortBU2IsSort (xs: List Nat) : msortbu2 xs == isort xs:= by sorry
