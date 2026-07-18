import Mathlib

structure Product where
  brand : String
  name : String
  price : Int

def sorted_brands (history : List Product) : List String :=
  sorry

theorem sorted_brands_unique_brands {history : List Product} : 
  let result := sorted_brands history
  List.length result = List.length (List.eraseDups result) := by
  sorry

theorem sorted_brands_subset {history : List Product} :
  let result := sorted_brands history
  match history with
  | [] => result = []
  | _ => result = (List.map (fun h => h.brand) history).eraseDups 
  := by 
  sorry

theorem sorted_brands_frequency_order {history : List Product} :
  let result := sorted_brands history
  let brand_counts := fun b => 
    (List.filter (fun h => h.brand = b) history).length
  ∀ (i j : Fin result.length), i.val < j.val →
    brand_counts (result[i]) ≥ brand_counts (result[j]) := by
  sorry

theorem sorted_brands_equal_freq_ordering {history : List Product} :
  let result := sorted_brands history
  let brand_counts := fun b => 
    (List.filter (fun h => h.brand = b) history).length
  let first_index := fun b => 
    Option.get! (List.findIdx? (fun h => h.brand = b) history)
  ∀ (i j : Fin result.length), i.val < j.val →
    brand_counts (result[i]) = brand_counts (result[j]) →
    first_index (result[i]) < first_index (result[j]) := by
  sorry
