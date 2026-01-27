extends Control

@onready var panel_container: PanelContainer = $PanelContainer
@onready var file_hflow: HFlowContainer = $PanelContainer/MarginContainer/FileHFlow
@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")


func clear_files() -> void:
	for child in file_hflow.get_children():
		child.queue_free()


func populate(attached_files: Array[FileData]) -> void:
	for file_data in attached_files:
		var file_instance := file_scene.instantiate()
		file_hflow.add_child(file_instance)
		file_instance.setup(file_data)
