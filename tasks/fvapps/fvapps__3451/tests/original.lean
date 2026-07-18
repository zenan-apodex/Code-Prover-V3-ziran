import Mathlib

namespace Property

def triangle (s : String) : String := sorry

theorem triangle_returns_single_char {s : String} 
  (h : ∀ c ∈ s.data, c = 'R' ∨ c = 'G' ∨ c = 'B') :
  (triangle s).length = 1 ∧ 
  (triangle s).data.head? = some 'R' ∨ 
  (triangle s).data.head? = some 'G' ∨ 
  (triangle s).data.head? = some 'B' := sorry

theorem triangle_single_char_identity {s : String}
  (h : s.length = 1)
  (h2 : ∀ c ∈ s.data, c = 'R' ∨ c = 'G' ∨ c = 'B') :
  triangle s = s := sorry 

theorem triangle_deterministic {s : String}
  (h : s.length ≥ 2)
  (h2 : ∀ c ∈ s.data, c = 'R' ∨ c = 'G' ∨ c = 'B') :
  triangle s = triangle s := sorry

theorem triangle_concatenation {s1 s2 : String}
  (h1 : s1.length > 0)
  (h2 : s2.length > 0)
  (h3 : ∀ c ∈ s1.data, c = 'R' ∨ c = 'G' ∨ c = 'B')
  (h4 : ∀ c ∈ s2.data, c = 'R' ∨ c = 'G' ∨ c = 'B') :
  (triangle (s1 ++ s2)).data.head? = some 'R' ∨
  (triangle (s1 ++ s2)).data.head? = some 'G' ∨
  (triangle (s1 ++ s2)).data.head? = some 'B' := sorry

end Property
