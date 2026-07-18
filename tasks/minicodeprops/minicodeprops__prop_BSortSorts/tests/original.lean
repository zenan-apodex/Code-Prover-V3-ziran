import Mathlib

def ordered : List Nat -> Bool
| []       => True
| [_x]     => True
| x::y::xs => x <= y && ordered (y::xs)


mutual
  def evens : List Nat → List Nat
  | [] => []
  | x::xs => x::(odds xs)
--
  def odds : List Nat → List Nat
  | [] => []
  | _x::xs => evens xs
end


lemma len_evens_le : (evens xs).length ≤ xs.length := by
  generalize hxsl: xs.length = xsl
  induction xsl using Nat.strong_induction_on generalizing xs with
  | h n ih =>
    cases xs with
    | nil => unfold evens; simp;
    | cons head1 tail1 =>
      unfold evens;
      cases tail1 with
      | nil => unfold odds; rw[← hxsl];
      | cons head2 tail2 =>
        unfold odds;
        rw [List.length_cons, List.length_cons] at hxsl;
        rw [← hxsl, List.length_cons, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _];
        simp;
        have h': List.length tail2 < n := by rw [← hxsl, Nat.succ_eq_add_one _]; linarith;
        exact Nat.le.step (ih (List.length tail2) h' rfl);


lemma len_odds_le : (odds xs).length ≤ xs.length := by
  generalize hxsl: xs.length = xsl
  induction xsl using Nat.strong_induction_on generalizing xs with
  | h n ih =>
    cases xs with
    | nil => unfold odds; simp;
    | cons head1 tail1 =>
      unfold odds;
      cases tail1 with
      | nil => unfold evens; simp;
      | cons head2 tail2 =>
        unfold evens;
        rw [List.length_cons, List.length_cons] at hxsl;
        rw [← hxsl, List.length_cons, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _];
        simp;
        have h': List.length tail2 < n := by rw [← hxsl, Nat.succ_eq_add_one _]; linarith;
        exact Nat.le.step (ih (List.length tail2) h' rfl);


def sort2 (a b: Nat): List Nat := if a ≤ b then [a,b] else [b, a]


def pairs : List Nat → List Nat → List Nat
| [], ys => ys
| xs, [] => xs
| x::xs, y::ys => (sort2 x y) ++ (pairs xs ys)


def stitch : List Nat → List Nat → List Nat
| [], ys => ys
| x::xs, ys => x::(pairs xs ys)


lemma bmerge_term (a b: Nat) (as bs: List Nat) (hlen: ¬(List.length as == 0 && List.length bs == 0) = true): List.length (evens (a :: as)) + List.length (evens (b :: bs)) < Nat.succ (List.length as) + Nat.succ (List.length bs) := by
    unfold evens;
    simp at hlen;
    rw [List.length_cons, List.length_cons, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _];
    ring_nf;
    cases as with
    | nil => cases bs with
      | nil => simp at hlen;
      | cons bhead btail => unfold odds; simp; linarith [@len_evens_le btail];
    | cons ahead atail =>
      rw [add_comm, add_comm (2 + List.length (ahead :: atail)) (List.length bs)]
      refine add_lt_add_of_le_of_lt (@len_odds_le bs) ?h; unfold odds; simp; linarith [@len_evens_le atail];


lemma bmerge_term2 (x y: Nat) (xs ys: List Nat) : List.length (odds (x :: xs)) + List.length (odds (y :: ys)) < Nat.succ (List.length xs) + Nat.succ (List.length ys) := by
  unfold odds;
  exact add_lt_add_of_lt_of_lt (Nat.lt_succ_of_le (@len_evens_le xs)) (Nat.lt_succ_of_le (@len_evens_le ys))


def bmerge : List Nat → List Nat → List Nat
| [], bs => bs -- I changed this from TIP. I don't believe this case is ever hit, though.
| as, [] => as
| x::xs, y::ys =>
  if hlen: xs.length == 0 && ys.length == 0 then sort2 x y else
  have _h := bmerge_term x y xs ys hlen;
  have _h2 := bmerge_term2 x y xs ys;
  stitch (bmerge (evens (x::xs)) (evens (y::ys))) (bmerge (odds (x::xs)) (odds (y::ys)))
termination_by xs ys => xs.length + ys.length


lemma bsort_term1 (x y: Nat) (xs: List Nat): List.length (evens (x :: y :: xs)) < Nat.succ (Nat.succ (List.length xs)) := by
  unfold evens; unfold odds;
  rw [List.length_cons, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _];
  simp;
  exact Nat.lt_succ_of_le (@len_evens_le xs);


lemma bsort_term2 (x y: Nat) (xs: List Nat): List.length (odds (x :: y :: xs)) < Nat.succ (Nat.succ (List.length xs)) := by
  unfold odds; unfold evens;
  rw [List.length_cons, Nat.succ_eq_add_one _, Nat.succ_eq_add_one _];
  simp;
  exact Nat.lt_succ_of_le (@len_odds_le xs);


def bsort : List Nat → List Nat
| [] => []
| [x] => [x]
| x::y::xs =>
  have _h := bsort_term1 x y xs
  have _h2 := bsort_term2 x y xs
  bmerge (bsort (evens (x::y::xs))) (bsort (odds (x::y::xs)))
termination_by xs => xs.length

theorem prop_BSortSorts (xs: List Nat) : ordered (bsort xs) == true:= by sorry
