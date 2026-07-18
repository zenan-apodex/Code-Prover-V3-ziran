import Mathlib

inductive TreeNode where
  | mk : Int → Option TreeNode → Option TreeNode → TreeNode

def arrayToTree : List (Option Int) → Option TreeNode := sorry
def treeToArray : Option TreeNode → List (Option Int) := sorry
def sufficientSubset : Option TreeNode → Int → Option TreeNode := sorry
def is_leaf : TreeNode → Bool := sorry
def path_sum : TreeNode → Int := sorry

theorem sufficient_subset_is_subset (tree : List (Option Int)) (limit : Int)
  (h : ∃ n, n ∈ tree ∧ n ≠ none) : 
  let root := arrayToTree tree
  let result := sufficientSubset root limit
  let result_arr := treeToArray result
  ∀ x ∈ result_arr, x ≠ none → x ∈ tree := sorry

theorem sufficient_subset_preserves_root (tree : List (Option Int)) (limit : Int)
  (h₁ : tree.length > 0)
  (h₂ : ∃ x, tree.head? = some (some x)) :
  let root := arrayToTree tree
  let result := sufficientSubset root limit
  let result_arr := treeToArray result
  result_arr.length > 0 → result_arr.head? = tree.head? := sorry

theorem sufficient_subset_leaf_property (tree : List (Option Int)) (limit : Int)
  (h : ∃ n, n ∈ tree ∧ n ≠ none) :
  let root := arrayToTree tree
  let result := sufficientSubset root limit
  match result with
  | none => True
  | some node => is_leaf node → path_sum node ≥ limit := sorry
