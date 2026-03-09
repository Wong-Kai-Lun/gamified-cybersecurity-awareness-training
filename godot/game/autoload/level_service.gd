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
var _total_false_reports: int = 0
#endregion


func reset() -> void:
	_current_day = Day.MONDAY
	_missed_purchase_orders = 0
	_total_false_reports = 0


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
		"current_day": _current_day,
		"missed_purchase_orders": _missed_purchase_orders,
		"total_false_reports": _total_false_reports
	}

func load_from_save(save_dict: Dictionary) -> void:
	_current_day = save_dict["current_day"]
	_missed_purchase_orders = save_dict["missed_purchase_orders"]
	_total_false_reports = save_dict["total_false_reports"] 
#endregion


# Progression
func validate_outbound_files(email: EmailData, attached: Array[FileData]) -> void:
	
	var expected_file_ids = []
	for file in email.expected_attachments:
		expected_file_ids.append(file.file_id)
	
	var attached_file_ids = []
	for file in attached:
		attached_file_ids.append(file.file_id)
	
	for id in expected_file_ids:
		if not attached_file_ids.has(id):
			_missed_purchase_orders += 1
	
	print("Missing Files: ", _missed_purchase_orders)
	check_actions()
	day_ended.emit()


# Check for any abuse of report functions
func check_actions():
	# get emails, check for number of legit emails as reported, trigger game over on condition, maybe this should be in email service?
	var player_emails := EmailServiceInstance.get_all_emails()
	
	_total_false_reports = 0
	for email in player_emails:
		if not email.is_phishing and email.flags["reported"]:
			_total_false_reports += 1
	
	print("Number of false reports: ", _total_false_reports)
