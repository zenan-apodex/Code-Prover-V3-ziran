import Mathlib

inductive FileType where
  | file
  | directory
  | symlink
  | character_file
  | block_file
  | pipe
  | socket
  | door
  deriving Repr, BEq

def linux_type (full_attr: String) : FileType := sorry

theorem linux_type_first_char_determines_type (file_type: Char) (permissions: String) 
  (h1: file_type = '-' ∨ file_type = 'd' ∨ file_type = 'l' ∨ 
       file_type = 'c' ∨ file_type = 'b' ∨ file_type = 'p' ∨
       file_type = 's' ∨ file_type = 'D')
  (h2: permissions.length = 9)
  (h3: ∀ c ∈ permissions.data, c = 'r' ∨ c = 'w' ∨ c = 'x' ∨ c = '-') :
  let full_attr := String.mk (file_type :: permissions.data)
  match file_type with
  | '-' => linux_type full_attr = FileType.file
  | 'd' => linux_type full_attr = FileType.directory
  | 'l' => linux_type full_attr = FileType.symlink
  | 'c' => linux_type full_attr = FileType.character_file
  | 'b' => linux_type full_attr = FileType.block_file
  | 'p' => linux_type full_attr = FileType.pipe
  | 's' => linux_type full_attr = FileType.socket
  | 'D' => linux_type full_attr = FileType.door
  | _ => True := sorry

theorem linux_type_invalid_first_char (c: Char) (permissions: String)
  (h1: c ≠ '-' ∧ c ≠ 'd' ∧ c ≠ 'l' ∧ c ≠ 'c' ∧ c ≠ 'b' ∧ c ≠ 'p' ∧ c ≠ 's' ∧ c ≠ 'D')
  (h2: permissions.length = 9)
  (h3: ∀ c ∈ permissions.data, c = 'r' ∨ c = 'w' ∨ c = 'x' ∨ c = '-') :
  ∀ ft: FileType, linux_type (String.mk (c :: permissions.data)) ≠ ft := sorry
