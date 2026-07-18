import Mathlib

def determine_media_types (associations : List (String × String)) (filenames : List String) : List String :=
sorry

theorem empty_associations_gives_unknown (filenames : List String) : 
  determine_media_types [] filenames = List.replicate filenames.length "unknown" := 
sorry
