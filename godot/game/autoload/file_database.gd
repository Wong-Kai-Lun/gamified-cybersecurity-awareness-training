extends Node
class_name FileDatabase

var _file_paths := {}

const FILE_DIRECTORIES := [
	"res://data/file/monday",
	"res://data/file/tuesday",
	"res://data/file/wednesday",
	"res://data/file/thursday",
	"res://data/file/friday"
]


func _ready():
	_build_database()


func _build_database() -> void:
	for dir_path in FILE_DIRECTORIES:
		var dir := DirAccess.open(dir_path)
		
		if dir == null:
			push_warning("File folder not found: %s" % dir_path)
			continue
		
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres") or file_name.ends_with(".tres.remap"):
				var id := file_name.get_basename().replace(".tres", "")
				var full_path = dir_path + "/" + id + ".tres"
				_file_paths[id] = full_path
			file_name = dir.get_next()
		dir.list_dir_end()


func get_file_path_by_id(file_id: String) -> String:
	return _file_paths.get(file_id, "")
