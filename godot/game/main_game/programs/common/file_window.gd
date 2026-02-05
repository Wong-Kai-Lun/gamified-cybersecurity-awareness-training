extends BaseWindow
class_name FileWindow

@export var file_container_path: NodePath

@onready var file_container: Control = get_node(file_container_path)
@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")


func draw_files(files: Array[FileData]) -> void:
	_clear_files()

	for file in files:
		var new_file = file_scene.instantiate()
		file_container.add_child(new_file)
		new_file.setup(file)


func _clear_files() -> void:
	for child in file_container.get_children():
		child.queue_free()
