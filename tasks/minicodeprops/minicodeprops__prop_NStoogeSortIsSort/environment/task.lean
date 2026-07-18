import Mathlib

def third : Nat → Nat
| 0 => 0
| 1 => 0
| 2 => 0
| n + 3 => 1 + (third n)


def insert' : Nat → List Nat → List Nat
| x, [] => [x]
| x, y::xs => if x <= y then x::y::xs else y::(insert x xs)


def isort: List Nat → List Nat
| [] => []
| x::xs => insert' x (isort xs)


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


lemma third_eq_div_3 : (x/3) = third x := by
  induction x using Nat.strongInductionOn with
  | ind x ih =>
  unfold third
  match x with
  | 0 => simp;
  | 1 => simp;
  | 2 => simp;
  | n + 3 => simp [Nat.succ_eq_add_one]; ring_nf; linarith [ih n (by linarith)]


def nstoogesort (xs : {xs : List Nat // xs.length = n}) : {ys: List Nat // ys.length = n} := match xs with
| ⟨[], h⟩ => ⟨[], h⟩
| ⟨[x], h⟩ => ⟨[x], h⟩
| ⟨[x, y], h⟩ => if x <= y then ⟨[x, y], h⟩ else ⟨[y, x], by simp [←h]⟩
| ⟨x1::x2::x3::xs, hlen⟩ =>
  let yzs1 := splitAt (third (x1::x2::x3::xs).length) (reverse (x1::x2::x3::xs))
  let ⟨tmp2, hlen2⟩ := (@nstoogesort yzs1.2.length ⟨yzs1.2, by rfl⟩)
  let s1s2a := tmp2 ++ (reverse yzs1.1)
  let yzs2 := splitAt (third s1s2a.length) s1s2a
  let ⟨tmp3, hlen3⟩ := (@nstoogesort yzs2.2.length ⟨yzs2.2, by rfl⟩)
  let s1s1 := yzs2.1 ++ tmp3
  let yzs3 := splitAt (third s1s1.length) (reverse s1s1)
  let ⟨tmp4, hlen4⟩ := (@nstoogesort yzs3.2.length ⟨yzs3.2, by rfl⟩)
  ⟨tmp4 ++ (reverse yzs3.1), by
    simp [hlen4, len_rev_eq_len];
    rw [add_comm];
    simp [splitAt_sum_preserves_len _ _ (Eq.refl yzs3), len_rev_eq_len];
    unfold_let s1s1
    simp [hlen3, splitAt_sum_preserves_len _ _ (Eq.refl yzs2)]
    unfold_let s1s2a
    simp [hlen2, len_rev_eq_len];
    rw [add_comm];
    simp [splitAt_sum_preserves_len _ _ (Eq.refl yzs1), len_rev_eq_len, hlen]
    ⟩
termination_by match xs with | ⟨lst, _h⟩ => lst.length
decreasing_by
  simp_wf
  apply splitAt_second_len_lt''
    (by simp [←third_eq_div_3, Nat.succ_eq_add_one, Nat.add_assoc])
    (by simp [len_rev_eq_len, Nat.succ_eq_add_one, Nat.add_assoc])
    (by simp [len_rev_eq_len, hlen])
  simp_wf
  suffices hyzs2 : (splitAt (List.length s1s2a / 3) s1s2a).2.length < n
  rw [List.length_append, third_eq_div_3] at hyzs2
  exact hyzs2;
  unfold_let s1s2a
  suffices hyzs1 : List.length (tmp2 ++ reverse yzs1.1) = List.length xs + 3
  exact splitAt_second_len_lt'' (by simp [hyzs1]) (by simp [hyzs1]) (by simp [hyzs1, ←hlen])
  simp [hlen2, len_rev_eq_len, Nat.add_comm, splitAt_sum_preserves_len _ _ (Eq.refl yzs1)]
  ring_nf
  simp_wf
  suffices hyzs3 : (splitAt (List.length s1s1 / 3) (reverse s1s1)).2.length < n
  unfold_let s1s1 yzs2 s1s2a yzs1 at hyzs3
  simp [List.length_append, third_eq_div_3] at hyzs3;
  exact hyzs3;
  suffices hs1s1: s1s1.length = xs.length + 3
  exact splitAt_second_len_lt'' (by simp [hs1s1]) (by simp [len_rev_eq_len, hs1s1]) (by simp [len_rev_eq_len, hs1s1, ←hlen])
  unfold_let s1s1
  simp [hlen3, splitAt_sum_preserves_len _ _ (Eq.refl yzs2)]
  unfold_let s1s2a
  simp [hlen2, len_rev_eq_len, Nat.add_comm, splitAt_sum_preserves_len _ _ (Eq.refl yzs1)]
  ring_nf


def nstoogesort' (xs: List Nat) := nstoogesort ⟨xs, (by rfl)⟩

theorem prop_NStoogeSortIsSort (xs: List Nat) : nstoogesort' xs == isort xs:= by sorry
