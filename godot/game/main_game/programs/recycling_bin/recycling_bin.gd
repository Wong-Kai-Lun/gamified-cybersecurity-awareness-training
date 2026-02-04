extends BaseWindow
class_name RecyclingBinWindow

@onready var recycling_bin_hflow: HFlowContainer = $WindowPanel/Structure/Content/VBoxContainer/MarginContainer/DeletedFilesHFlow
@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")


func _ready() -> void:
	super._ready()
	GameManagerInstance.recycling_bin_changed.connect(_draw_files)


func _draw_files(recycling_bin: Array[FileData]) -> void:
	_clear_files()
	
	for file in recycling_bin:
		var new_file = file_scene.instantiate()
		recycling_bin_hflow.add_child(new_file)
		new_file.setup(file)


func _clear_files() -> void:
	for file in recycling_bin_hflow.get_children():
		file.queue_free()


func _on_empty_bin_button_pressed() -> void:
	GameManagerInstance.empty_recycling_bin()
