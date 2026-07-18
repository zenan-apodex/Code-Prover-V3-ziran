import Mathlib

def domain_name (url : String) : String := sorry

theorem basic_domain_extraction :
  domain_name "http://google.com" = "google" ∧
  domain_name "http://www.zombie-bites.com" = "zombie-bites" ∧
  domain_name "icann.org" = "icann" := sorry

theorem domain_name_no_protocols (domain tld : String) :
  let url := s!"http://www.{domain}.{tld}"
  domain_name url ≠ "www" ∧
  domain_name url ≠ "http" ∧
  domain_name url ≠ "https" ∧
  ¬(domain_name url).contains '.' := sorry
