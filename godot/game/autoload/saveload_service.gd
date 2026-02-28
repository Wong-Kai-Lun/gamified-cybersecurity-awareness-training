extends Node
class_name SaveLoadService

var _pending_load: bool = false

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
	
	GameManagerInstance.load_from_save(loaded_dict["player_info"])
	LevelServiceInstance.load_from_save(loaded_dict["level_info"])
	EmailServiceInstance.load_from_save(loaded_dict["player_emails"])
	FileServiceInstance.load_from_save(loaded_dict["player_files"])


func continue_game() -> void:
	_pending_load = true
	get_tree().change_scene_to_file("res://game/main_game/desktop.tscn")

func should_finish_loading() -> bool:
	return _pending_load

func finish_loading() -> void:
	load_game()
	_pending_load = false
