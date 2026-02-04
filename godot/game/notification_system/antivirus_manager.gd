extends Node
class_name AntivirusManager

signal malware_found

func scan_player_inventory() -> void:
	var player_inventory = GameManagerInstance.get_player_inventory()
	
	for file in player_inventory:
		print(file.file_name)
		print(file.FileType)
