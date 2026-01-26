extends Control

@onready var outbound_hflow: HFlowContainer = $PanelContainer/MarginContainer/OutboundHFlow
@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")

# add a field in outbound for "expected files" array
var outbound_file_array: Array[FileData] = []

# add some visual feedback
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is FileData

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var outbound_file_data = GameManagerInstance.change_inventory_to_outbound(data)
	var file_instance := file_scene.instantiate()
	outbound_hflow.add_child(file_instance)
	file_instance.setup(outbound_file_data)
	file_instance.remove_requested.connect(_remove_outbound_file_data)
	outbound_file_array.append(outbound_file_data)

func _remove_outbound_file_data(file_data: FileData) -> void:
	outbound_file_array.erase(file_data)
