extends Node
class_name LevelService

signal level_updated(level: Dictionary)

enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }

const LEVELS = {
	Day.MONDAY: {
		"name" : "Monday",
		"email_pack" : preload("res://data/email_pack/monday.tres")
	},
	Day.TUESDAY: {
		"name" : "Tuesday",
		"email_pack" : preload("res://data/email_pack/tuesday.tres")
	},
	Day.WEDNESDAY: {
		"name" : "Wednesday",
		# "email_pack" : preload("res://data/email_pack/wednesday.tres")
	}
}

# Player Value
var _current_day: Day = Day.MONDAY


func _ready() -> void:
	print("LevelService online!")
	get_email_pack_of_day()


func get_data_for_save() -> Dictionary:
	return {
		"current_day": _current_day
	}


func advance_day() -> void:
	_current_day += 1
	#level_updated.emit(current_day)


func initialise() -> void:
	_current_day = Day.MONDAY
	#change current_day if save file exists
	level_updated.emit(LEVELS[_current_day])


func get_current_level_name() -> String:
	return LEVELS[_current_day].get("name")


func get_email_pack_of_day() -> EmailPack:
	return LEVELS[_current_day].get("email_pack")


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


func end_day() -> void:
	advance_day()
