extends Node
class_name GameManager

#region Saveable Data
# Default Values
var _player_name: String = "Placeholder"
var _player_email_username: String = "place.holder"
#endregion


func register_player(username: String, email: String) -> void:
	_player_name = username
	_player_email_username = email

func get_player_info() -> Dictionary:
	return {
		"name": _player_name,
		"email_username": _player_email_username
	}


func start_new_game() -> void:
	LevelServiceInstance.reset()
	EmailServiceInstance.reset()
	FileServiceInstance.reset()
	
	var pack := LevelServiceInstance.get_email_pack_of_day()
	EmailServiceInstance.append_latest_email_data(pack)


#region Save / Load Data
func get_data_for_save() -> Dictionary:
	return {
		"player_name": _player_name,
		"player_email_username": _player_email_username
	}

func load_from_save(save_dict: Dictionary) -> void:
	_player_name = save_dict["player_name"]
	_player_email_username = save_dict["player_email_username"]
#endregion
