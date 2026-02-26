extends Node
class_name GameManager

# Default Values
var _player_name: String = "Placeholder"
var _player_email_username: String = "place.holder"


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
	
	var day := LevelServiceInstance.get_current_day()
	var pack := LevelServiceInstance.get_email_pack_of_day(day)
	EmailServiceInstance.append_latest_email_data(pack)
	LevelServiceInstance.get_email_pack_of_day(day)


#region Save / Load Data
func get_data_for_save() -> Dictionary:
	return {
		"player": {
			"player_name": _player_name,
			"player_email_username": _player_email_username
		}
	}

func load_data() -> void:
	pass
#endregion
