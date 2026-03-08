extends Node
class_name LevelService

signal level_updated
signal day_ended

enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY }

const LEVELS = {
	Day.MONDAY: "res://data/email_pack/monday.tres",
	Day.TUESDAY: "res://data/email_pack/tuesday.tres",
	Day.WEDNESDAY: "res://data/email_pack/wednesday.tres",
	Day.THURSDAY: "res://data/email_pack/thursday.tres",
	Day.FRIDAY: "res://data/email_pack/friday.tres"
}

#region Saveable Data
var _current_day: Day = Day.MONDAY
var _missed_purchase_orders: int = 0
#endregion


func reset() -> void:
	_current_day = Day.MONDAY


func advance_day() -> void:
	if _current_day < Day.FRIDAY:
		_current_day += 1


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
			missing_file_count += 1
	
	print("Missing Files: ", missing_file_count)
	day_ended.emit()


# Check for any abuse of report functions
func check_actions():
	# get emails, check for number of legit emails as reported, trigger game over on condition, maybe this should be in email service?
	pass
