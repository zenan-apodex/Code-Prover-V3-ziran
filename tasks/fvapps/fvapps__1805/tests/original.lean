import Mathlib

def PersonId := Nat
def Video := String
def WatchedVideos := List (List Video)
def Friends := List (List PersonId)

instance : Inhabited PersonId where
  default := Nat.zero

def watched_videos_by_friends (watchedVideos : WatchedVideos) 
  (friends : Friends) (id : PersonId) (level : Nat) : List Video := sorry

theorem watched_videos_by_friends_result_subset_all_videos 
  (watchedVideos : WatchedVideos) (friends : Friends) 
  (id : PersonId) (level : Nat) :
  let result := watched_videos_by_friends watchedVideos friends id level
  let allVideos := List.join watchedVideos
  ∀ v, v ∈ result → v ∈ allVideos := sorry

theorem friends_lists_symmetric
  (friends : Friends) (i j : Nat) (h1 : i < friends.length) (h2 : j < friends.length)
  (h3 : j ∈ List.get! friends i) :
  i ∈ List.get! friends j := sorry

theorem friends_lists_ascending
  (friends : Friends) (i : Nat) (h : i < friends.length) (x y : Nat) :
  x ∈ List.get! friends i → y ∈ List.get! friends i → x ≤ y ∨ y ≤ x := sorry

theorem friends_lists_unique
  (friends : Friends) (i : Nat) (h : i < friends.length) :
  List.Nodup (List.get! friends i) := sorry

theorem friends_not_self_referential
  (friends : Friends) (i : Nat) (h : i < friends.length) :
  i ∉ List.get! friends i := sorry
