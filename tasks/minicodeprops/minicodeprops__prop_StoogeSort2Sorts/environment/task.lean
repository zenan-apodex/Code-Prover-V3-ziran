import Mathlib

def ordered : List Nat -> Bool
| []       => True
| [_x]     => True
| x::y::xs => x <= y && ordered (y::xs)


def splitAt : Nat → List Nat → (List Nat × List Nat)
| _n, [] => ([], [])
| 0, xs => ([], xs)
| n + 1, x::xs => match splitAt n xs with
  | (l1, l2) => (x::l1, l2)


def reverse : List Nat → List Nat
| [] => []
| x::xs => (reverse xs) ++ [x]


lemma len_rev_eq_len {l: List Nat} : (reverse l).length = l.length := by
  induction l with
  | nil => simp [reverse]
  | cons head tail ih => unfold reverse; simp [ih];


lemma splitAt_len_le : (splitAt n xs).2.length ≤ xs.length := by
  induction xs generalizing n with
  | nil => unfold splitAt; simp;
  | cons head tail ih =>
    cases n with
    | zero => unfold splitAt; simp;
    | succ nm1 => unfold splitAt; simp; apply Nat.le.step; exact ih;


lemma splitAt_second_len_lt (n: Nat): (splitAt n.succ (x::xs)).2.length < (x::xs).length := by
  unfold splitAt;
  simp;
  calc List.length (splitAt n xs).2 ≤ (List.length xs) := splitAt_len_le
       _                          < Nat.succ (List.length xs) := Nat.lt_succ_self _


lemma splitAt_second_len_lt' (n: Nat) (hlen: xs.length > 0): (splitAt n.succ xs).2.length < xs.length := by
  cases xs with
  | nil => simp at hlen;
  | cons x xs => exact splitAt_second_len_lt _;


lemma splitAt_second_len_lt'' (hn: n > 0) (hlen: xs.length > 0) (hlen': xl = xs.length): (splitAt n xs).2.length < xl := by
  cases n with
  | zero => simp at hn;
  | succ nm1 => rw [hlen']; exact splitAt_second_len_lt' _ hlen;


lemma splitAt_sum_preserves_len (n: Nat) (xs: List Nat) (hspl: spl = splitAt n xs):
  (spl.1.length + spl.2.length = xs.length) := by
  induction xs generalizing n spl with
  | nil => simp [splitAt] at hspl; simp [hspl];
  | cons head tail ih => cases n with
    | zero => simp [splitAt] at hspl; simp [hspl];
    | succ nm1 =>
      simp [splitAt] at hspl;
      simp [hspl]
      rw [Nat.succ_add];
      apply Order.succ_eq_succ_iff.2
      exact ih nm1 (by rfl);


lemma splitAt_first_len_lt (hn: n < xl) (hlen': xl = xs.length): (splitAt n xs).1.length < xl := by
  suffices heq : (splitAt n xs).1.length = n
  simp [heq, hn]
  induction xs generalizing n xl with
  | nil => simp [hlen'] at hn;
  | cons head tail ih =>
    cases n with
    | zero => simp [splitAt];
    | succ nm1 =>
      simp [splitAt];
      exact @ih nm1 tail.length (by simp [hlen'] at hn; exact hn) rfl


lemma twon_lt (n: Nat): (2*n.succ.succ.succ + 1)/ 3 < n.succ.succ.succ := by
  simp [Nat.succ_eq_add_one];
  ring_nf;
  rw [Nat.div_lt_iff_lt_mul (by simp)];
  ring_nf;
  linarith;


def stoogesort2 (xs : {xs : List Nat // xs.length = n}) : {ys: List Nat // ys.length = n} := match xs with
| ⟨[], h⟩ => ⟨[], h⟩
| ⟨[x], h⟩ => ⟨[x], h⟩
| ⟨[x, y], h⟩ => if x <= y then ⟨[x, y], h⟩ else ⟨[y, x], by simp [←h]⟩
| ⟨x1::x2::x3::xs, hlen⟩ =>
  let yzs1 := splitAt ((2*(x1::x2::x3::xs).length + 1) / 3) (x1::x2::x3::xs)
  let ⟨tmp2, hlen2⟩ := @stoogesort2 yzs1.1.length ⟨yzs1.1, by rfl⟩
  let s2s2a := tmp2 ++ yzs1.2
  let yzs2 := splitAt (s2s2a.length / 3) s2s2a
  let ⟨tmp3, hlen3⟩ := @stoogesort2 yzs2.2.length ⟨yzs2.2, by rfl⟩
  let s2s1 := yzs2.1 ++ tmp3
  let yzs3 := splitAt ((2*s2s1.length + 1) / 3) s2s1
  let ⟨tmp4, hlen4⟩ := @stoogesort2 yzs3.1.length ⟨yzs3.1, by rfl⟩
  ⟨tmp4 ++ yzs3.2, by
    simp [hlen4];
    simp [splitAt_sum_preserves_len _ _ (Eq.refl yzs3), len_rev_eq_len];
    unfold_let s2s1
    simp [hlen3, splitAt_sum_preserves_len _ _ (Eq.refl yzs2)]
    unfold_let s2s2a
    simp [hlen2];
    simp [splitAt_sum_preserves_len _ _ (Eq.refl yzs1), hlen]
    ⟩
termination_by match xs with | ⟨lst, _h⟩ => lst.length
decreasing_by
  simp_wf;
  simp at hlen;
  rw [← hlen]
  apply splitAt_first_len_lt (twon_lt _) (by simp)
  simp_wf;
  suffices hyzs2 : yzs2.2.length < n
  unfold_let yzs2 at hyzs2
  rw [List.length_append] at hyzs2
  exact hyzs2;
  unfold_let yzs2
  suffices hs2s2a : s2s2a.length = n
  rw [hs2s2a, ← hlen]
  apply splitAt_second_len_lt'' (by simp [Nat.succ_eq_add_one, Nat.add_assoc]) (by simp [hs2s2a, ←hlen]) (by simp [hs2s2a, ←hlen])
  unfold_let s2s2a
  simp [hlen2, splitAt_sum_preserves_len _ _ (Eq.refl yzs1), hlen]
  simp_wf;
  suffices hdone: yzs3.1.length < n
  unfold_let yzs3 s2s1 yzs2 s2s2a yzs1 at hdone
  simp [List.length_append] at hdone;
  exact hdone;
  unfold_let yzs3
  suffices hs2s1: s2s1.length = xs.length.succ.succ.succ
  refine splitAt_first_len_lt (by simp [hs2s1, ← hlen]; exact twon_lt _) (by simp [hs2s1, ← hlen])
  unfold_let s2s1
  simp [hlen3, splitAt_sum_preserves_len _ _ (Eq.refl yzs2)]
  unfold_let s2s2a
  simp [hlen2, len_rev_eq_len, Nat.add_comm, splitAt_sum_preserves_len _ _ (Eq.refl yzs1)]
  ring_nf


def stoogesort2' (xs: List Nat) := stoogesort2 ⟨xs, by rfl⟩

theorem prop_StoogeSort2Sorts (xs: List Nat) : ordered (stoogesort2' xs) == true:= by sorry
