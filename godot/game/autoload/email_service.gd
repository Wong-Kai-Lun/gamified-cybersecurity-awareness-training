extends Node
class_name EmailService

var _COMPANY_DOMAIN = "@abc.com.my"
var _PLACEHOLDER_NAME = "{player_name}"
var _PLACEHOLDER_EMAIL = "{player_email}"


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
