import Mathlib

def subarraysDivByK (nums : List Int) (k : Int) : Int := sorry

def countSubarraysDivisibleByK (nums : List Int) (k : Int) (i : Nat) (sum : Int) (count : Int) : Int :=
  if h : i < nums.length then
    let newSum := sum + nums[i]'h
    if newSum % k = 0 then
      countSubarraysDivisibleByK nums k (i + 1) newSum (count + 1)
    else  
      countSubarraysDivisibleByK nums k (i + 1) newSum count
  else
    count
termination_by nums.length - i





theorem single_element_divisible (k : Int)
  (h : k > 0) :
  subarraysDivByK [k] k = 1 := sorry
