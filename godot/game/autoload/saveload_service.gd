extends Node
class_name SaveLoadService

var is_new_game := true


func gather_save_data() -> Dictionary:
	return {
		"level": LevelServiceInstance.get_data_for_save(),
		"game": GameManagerInstance.get_data_for_save()
	}


func test() -> void:
	var test_dict := gather_save_data()
	print(test_dict)
