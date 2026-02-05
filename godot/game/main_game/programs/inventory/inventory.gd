extends BaseWindow
class_name InventoryWindow

@onready var inventory_file_container: HFlowContainer = $WindowPanel/Structure/Content/HBoxContainer/ScrollContainer/MarginContainer/HFlowContainer
@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")


func _ready() -> void:
	super._ready()
	GameManagerInstance.inventory_changed.connect(_draw_files)


# Activates when player inventory changes.
func _draw_files(inventory: Array[FileData]) -> void:
	_clear_files()
		
	for file in inventory:
		var new_file = file_scene.instantiate()
		inventory_file_container.add_child(new_file)
		new_file.setup(file)


func _clear_files() -> void:
	for file in inventory_file_container.get_children():
		file.queue_free()
