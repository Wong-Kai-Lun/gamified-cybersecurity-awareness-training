extends Node
class_name EmailService

signal emails_updated(emails: Array[EmailData])

const _COMPANY_DOMAIN = "@abc.com.my"
const _PLACEHOLDER_NAME = "{player_name}"
const _PLACEHOLDER_EMAIL = "{player_email}"

var _player_emails: Array[EmailData] = []


func reset() -> void:
	_player_emails.clear()
	emails_updated.emit(_player_emails.duplicate(true))


#region Save / Load
func get_data_for_save() -> Array:
	var result := []
	
	for email in _player_emails:
		var save_data := email.get_save_data()
		result.append(save_data)
	
	return result


func load_from_save(email_array: Array) -> void:
	reset()
	
	for email_dict in email_array:
		var instance = _rebuild_email_from_save(email_dict)
		_player_emails.append(instance)
	
	emails_updated.emit(_player_emails.duplicate(true))


func _rebuild_email_from_save(email_dict: Dictionary) -> EmailData:
	var email_id = email_dict["id"]
	var outbound_files = email_dict["outbound_files"]
	
	var path = EmailDatabaseInstance.get_email_path_by_id(email_id)
	var email_def = load(path) as EmailData
	var instance = email_def.duplicate(true)
	
	for file_id in outbound_files:
		var file_instance = FileServiceInstance.rebuild_file_from_save(file_id, FileData.FileContext.OUTBOUND)
		instance.outbound_attachments.append(file_instance)
	
	instance.flags = email_dict["flags"]
	
	return instance
#endregion


# Updates placeholders in email_body
func replace_placeholder_email_address(to_address: String) -> String:
	var player_info := GameManagerInstance.get_player_info()
	var email_address = player_info["email_username"] + _COMPANY_DOMAIN
	var updated_to_address = to_address.replace(_PLACEHOLDER_EMAIL, email_address)
	return updated_to_address


func replace_placeholder_name(email_body: String) -> String:
	var player_info := GameManagerInstance.get_player_info()
	var updated_email_body = email_body.replace(_PLACEHOLDER_NAME, player_info["name"])
	return updated_email_body


func get_all_emails() -> Array[EmailData]:
	return _player_emails.duplicate(true)


func append_latest_email_data() -> void:
	var email_pack := LevelServiceInstance.get_email_pack_of_day()
	var latest_email_array := email_pack.emails
	
	for email_data in latest_email_array:
		_player_emails.append(email_data)
	
	emails_updated.emit(_player_emails.duplicate(true))


func append_email(email_instance: EmailData) -> void:
	_player_emails.append(email_instance)
	emails_updated.emit(_player_emails.duplicate(true))


# add special event/email here
# first malware attached email > final warning, second > termination
func trigger_special_email():
	pass
