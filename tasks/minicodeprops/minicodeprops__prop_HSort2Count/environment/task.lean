import Mathlib

def count [DecidableEq α] : α → List α → Nat
| _x, [] => 0
| x, y::ys => if x == y then 1 + (count x ys) else count x ys


inductive MyHeap where
| nil : MyHeap
| node : MyHeap → Nat → MyHeap  →  MyHeap


def hmerge : MyHeap  → MyHeap  → MyHeap
| MyHeap.nil, q => q
| p, MyHeap.nil => p
| MyHeap.node p x q, MyHeap.node r y s =>
  if x <= y then MyHeap.node (hmerge q (MyHeap.node r y s)) x p
            else MyHeap.node (hmerge (MyHeap.node p x q) s) y r


def numElem : MyHeap → Nat
| MyHeap.nil => 0
| MyHeap.node p _x q => 1 + numElem p + numElem q


lemma numElem_lt_subHeaps  (q r: MyHeap) {x: Nat}: numElem q < numElem (MyHeap.node q x r) ∧ numElem r < numElem (MyHeap.node q x r) := by
  have h': numElem (MyHeap.node q x r) = 1 + numElem q + numElem r; rfl
  rw [h'];
  exact ⟨by linarith, by linarith⟩;


lemma merge_elems (p q: MyHeap): numElem p + numElem q = numElem (hmerge p q) := by
  generalize hsp: numElem p = sp
  generalize hsq: numElem q = sq
  generalize hspq: numElem (hmerge p q) = spq
  induction sp using Nat.strong_induction_on generalizing p q sq spq with
  | h sp2 ih =>   induction sq using Nat.strong_induction_on generalizing p q sp2 spq with
    | h sq2 ih2 =>
    rw [←hsp, ← hsq, ← hspq];
    unfold hmerge;
    split;
    case h_1 _ _;
      unfold numElem; rw [Nat.add_comm, Nat.add_zero];
    case h_2 _ _;
      unfold numElem; rw [Nat.add_zero];
    case h_3 _ _ pl x pr ql y qr;
      split;
        unfold numElem;
        suffices h': numElem (hmerge pr (MyHeap.node ql y qr)) = numElem pr + (1 + numElem ql + numElem qr);
          rw[h']; linarith;
        rw [←hsp] at ih;
        exact Eq.symm (ih (numElem pr) (numElem_lt_subHeaps _ _).2 pr (MyHeap.node ql y qr) rfl
          (numElem (MyHeap.node ql y qr)) rfl (numElem (hmerge pr (MyHeap.node ql y qr))) rfl);
        unfold numElem;
        suffices h': numElem (hmerge (MyHeap.node pl x pr) qr) = numElem qr + (1 + numElem pl + numElem pr);
          rw[h']; linarith;
        rw [←hsq] at ih2;
        have h':= ih2 (numElem qr) (numElem_lt_subHeaps _ _).2 sp2 ih (MyHeap.node pl x pr) qr hsp rfl
          (numElem (hmerge (MyHeap.node pl x pr) qr)) rfl;
        rw [←hsp] at h';
        suffices h'': 1 + numElem pl + numElem pr = numElem (MyHeap.node pl x pr);
          rw [h'']; linarith;
        rfl;


lemma numElem_merge_branches_lt (p q: MyHeap) (x: Nat): numElem (hmerge p q) < numElem (MyHeap.node p x q) := by
  rw [←merge_elems _ _];
  have h': numElem (MyHeap.node p x q) = 1 + numElem p + numElem q; rfl
  rw [h']
  linarith;


def toList : MyHeap → List Nat
| MyHeap.nil => []
| MyHeap.node p x q =>
    have _h := numElem_merge_branches_lt p q x
    x :: toList (hmerge p q)
termination_by hp => numElem hp


def hinsert : Nat → MyHeap → MyHeap
| x, h => hmerge (MyHeap.node MyHeap.nil x MyHeap.nil) h


def toHeap2 : List Nat → MyHeap
| [] => MyHeap.nil
| x::xs => hinsert x (toHeap2 xs)


def hsort2 : List Nat → List Nat
| xs => toList (toHeap2 xs)

theorem prop_HSort2Count (x: Nat) (xs: List Nat) : count x (hsort2 xs) == count x xs:= by sorry
