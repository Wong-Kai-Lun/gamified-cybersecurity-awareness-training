extends Node
class_name SaveLoadService


func save_game() -> void:
	var save_data := {
		"player_info": GameManagerInstance.get_data_for_save(),
		"level_info": LevelServiceInstance.get_data_for_save(),
		"player_emails": EmailServiceInstance.get_data_for_save(),
		"player_files": FileServiceInstance.get_data_for_save()
	}
	
	var file = FileAccess.open("user://save_file.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data, "\t"))
	file.close()


func load_game() -> void:
	var file := FileAccess.open("user://save_file.json", FileAccess.READ)
	var content = file.get_as_text()
	var loaded_dict = JSON.parse_string(content)
	print(loaded_dict["player_info"])
	print(loaded_dict["level_info"])
	print(loaded_dict["player_files"])
