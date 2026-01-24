extends BaseWindow
class_name InventoryWindow

@onready var inventory_file_container: HFlowContainer = $WindowPanel/Structure/Content/HBoxContainer/ScrollContainer/MarginContainer/HFlowContainer
@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	GameManagerInstance.inventory_changed.connect(add_file_to_container)

# GameManager changes state, UI redraw.
func add_file_to_container(inventory: Array[FileData]) -> void:
	for child in inventory_file_container.get_children():
		child.queue_free()
	
	for file in inventory:
		var new_file_instance = file_scene.instantiate()
		inventory_file_container.add_child(new_file_instance)
		new_file_instance.setup(file)
	
