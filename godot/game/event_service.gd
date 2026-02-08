extends Node
class_name EventService

var _malware_count = 0


func _ready() -> void:
	print("EventService online!")


func check_inventory() -> void:
	var player_inventory = GameManagerInstance.get_player_inventory()
	_calculate_malware(player_inventory)
	print("EventService Malware Counter: ", _malware_count)


func _calculate_malware(inventory_array: Array[FileData]) -> void:
	for file in inventory_array:
		if file.file_type == FileData.FileType.MALWARE:
			_malware_count += 1
