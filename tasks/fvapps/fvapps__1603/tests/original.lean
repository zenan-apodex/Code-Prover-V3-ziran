import Mathlib

structure Url where
  hostname : String
  path : String

def find_website_groups (urls : List String) : List (List String) := sorry

theorem groups_return_type (urls : List String) : 
  let result := find_website_groups urls
  result.all (fun group => group.all (fun _ => true)) := sorry

theorem groups_min_size (urls : List String) :
  let result := find_website_groups urls
  result.all (fun group => group.length > 1) := sorry

theorem hostnames_appear_once (urls : List String) :
  let result := find_website_groups urls
  let all_hostnames := result.bind id
  all_hostnames.length = (all_hostnames.eraseDups).length := sorry

theorem empty_paths_normalized (urls : List String) (h : String) :
  let test_urls := urls ++ [s!"http://{h}", s!"http://{h}/"]
  let result := find_website_groups test_urls
  result.all (fun group => 
    if group.contains h then group.count h = 1 
    else true) := sorry
