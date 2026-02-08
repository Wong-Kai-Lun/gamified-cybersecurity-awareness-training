extends Node
class_name EventService

var _malware_count = 0


func _ready() -> void:
	print("EventService online!")


func check_inventory() -> void:
	var inventory_array = GameManagerInstance.get_player_inventory()
	
	for file in inventory_array:
		if file.file_type == FileData.FileType.MALWARE:
			_malware_count += 1
	
	print("EventService Malware Counter: ", _malware_count)
