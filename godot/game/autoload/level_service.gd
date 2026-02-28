extends Node
class_name LevelService

signal level_updated(day: Day)

enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }

const LEVELS = {
	Day.MONDAY: "res://data/email_pack/monday.tres",
	Day.TUESDAY: "res://data/email_pack/tuesday.tres"
	# Day.WEDNESDAY: preload("res://data/email_pack/monday.tres")
}

#region Saveable Data
var _current_day: Day = Day.MONDAY
#endregion


func _ready() -> void:
	print("LevelService online!")


func get_current_day() -> Day:
	return _current_day


func get_current_level_name() -> String:
	var email_pack := load(LEVELS[_current_day])
	return email_pack.pack_name


func get_email_pack_of_day() -> EmailPack:
	var email_pack := load(LEVELS[_current_day])
	return email_pack


#region Save / Load
func get_data_for_save() -> Dictionary:
	return {
		"current_day": _current_day
	}

func load_from_save(save_dict: Dictionary) -> void:
	_current_day = save_dict["current_day"]
#endregion

func advance_day() -> void:
	_current_day = min(_current_day + 1, Day.FRIDAY)
		#level_updated.emit(current_day)


func reset() -> void:
	_current_day = Day.MONDAY
	# change current_day if save file exists


# Progression
func validate_outbound_files(email: EmailData, attached: Array[FileData]) -> void:
	var expected_file_ids = []
	for file in email.expected_attachments:
		expected_file_ids.append(file.file_id)
	
	var attached_file_ids = []
	for file in attached:
		attached_file_ids.append(file.file_id)
	
	var missing_file_count = 0
	for id in expected_file_ids:
		if not attached_file_ids.has(id):
			print("An expected file is not attached!", id)
			missing_file_count += 1
	
	print("Missing Files: ", missing_file_count)
