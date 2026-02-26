extends Node
class_name EmailService

signal emails_updated

var _COMPANY_DOMAIN = "@abc.com.my"
var _PLACEHOLDER_NAME = "{player_name}"
var _PLACEHOLDER_EMAIL = "{player_email}"

var _player_emails: Array[EmailData] = []


# Save / Load
func reset() -> void:
	_player_emails.clear()
	emails_updated.emit()

func get_data_for_save() -> Array:
	var result := []
	
	for email in _player_emails:
		var save_data := email.get_save_data()
		result.append(save_data)
	
	return result


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
	return _player_emails


func append_latest_email_data(email_pack: EmailPack) -> void:
	var latest_email_array := email_pack.emails
	for email_data in latest_email_array:
		_player_emails.append(email_data)
	emails_updated.emit()
