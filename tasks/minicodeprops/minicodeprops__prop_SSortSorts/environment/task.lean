import Mathlib

def deleteFirst [DecidableEq α]: α → List α → List α
  | _, [] => []
  | n, x::xs => if n == x then xs else x::(deleteFirst n xs)


def ordered : List Nat -> Bool
| []       => True
| [_x]     => True
| x::y::xs => x <= y && ordered (y::xs)


def minimum : Nat → List Nat → Nat
| x, [] => x
| x, y::ys => if y <= x then minimum y ys else minimum x ys


lemma min_in_list : minimum x xs ∈ (x::xs) := by
  induction xs generalizing x with
  | nil => unfold minimum; simp;
  | cons head tail ih =>
    unfold minimum; split_ifs with h1;
    case pos;
      rw [List.mem_cons]; right; exact ih;
    case neg;
      rw [List.mem_cons];
      cases (List.mem_cons.1 (@ih x)) with
      | inl h2 => left; exact h2;
      | inr h2 => right; rw [List.mem_cons]; right; exact h2;


lemma delete_len_eq {x: Nat} {xs: List Nat} (h: x ∈ xs): (deleteFirst x xs).length + 1 = xs.length := by
  generalize hxsl: xs.length = xsl
  induction xsl generalizing xs with
  | zero => rw [List.length_eq_zero] at hxsl; simp [hxsl] at h;
  | succ n ih =>
    cases xs with
    | nil => simp at hxsl;
    | cons head tail =>
      unfold deleteFirst;
      split_ifs with h1;
      case pos;
        simp at hxsl;
        simp [hxsl];
      case neg;
        rw [List.mem_cons] at h;
        simp at h1;
        simp at hxsl;
        simp;
        exact ih ((or_iff_right h1).1 h) hxsl;


def ssort : List Nat → List Nat
| [] => []
| x::xs =>
  let m := minimum x xs
  have _h: List.length (deleteFirst (minimum x xs) (x :: xs)) < Nat.succ (List.length xs) := by
    have tmp := delete_len_eq (@min_in_list x xs)
    simp at tmp;
    simp [tmp];
  m :: ssort (deleteFirst m (x::xs))
termination_by xs => xs.length

theorem prop_SSortSorts (xs: List Nat) : ordered (ssort xs) == true:= by sorry
