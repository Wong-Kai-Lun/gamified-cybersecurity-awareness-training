extends Node
class_name EmailDatabase

var _email_paths := {}

const EMAIL_DIRECTORIES := [
	"res://data/email/monday",
	"res://data/email/tuesday",
	"res://data/email/wednesday"
]


func _ready():
	_build_database()


func _build_database() -> void:
	for dir_path in EMAIL_DIRECTORIES:
		var dir := DirAccess.open(dir_path)
		
		if dir == null:
			push_warning("Email folder not found: %s" % dir_path)
			continue
		
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var id := file_name.get_basename()
				var full_path = dir_path + "/" + file_name
				_email_paths[id] = full_path
			file_name = dir.get_next()
		dir.list_dir_end()


func get_email_path_by_id(email_id: String) -> String:
	return _email_paths.get(email_id, "")
