import Mathlib

structure Permissions where
  user : Option String := none
  group : Option String := none
  other : Option String := none

def chmod_calculator (perms : Permissions) : String := sorry

theorem empty_dict_gives_zeros :
  chmod_calculator {} = "000" := sorry

theorem known_values_first :
  chmod_calculator { user := some "rwx", group := some "r-x", other := some "r-x" } = "755" := sorry

theorem known_values_second :
  chmod_calculator { user := some "rw-", group := some "r--", other := some "r--" } = "644" := sorry

theorem group_only_rwx :
  chmod_calculator { group := some "rwx" } = "070" := sorry

theorem user_rw_other_r :
  chmod_calculator { user := some "rw-", other := some "r--" } = "604" := sorry
