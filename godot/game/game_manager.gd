extends Node
class_name GameManager

signal inventory_changed(inventory: Array[FileData])
signal inventory_full
signal recycling_bin_changed(recycling_bin: Array[FileData])


# Constant Values
var _COMPANY_DOMAIN = "@abc.com.my"
var _PLACEHOLDER_NAME = "{player_name}"
var _PLACEHOLDER_EMAIL = "{player_email}"
var _MAX_INVENTORY_SIZE = 16

var _player_name: String = "Placeholder"
var _player_email: String = "place.holder" + _COMPANY_DOMAIN
var _inventory: Array[FileData] = []
var _recycling_bin: Array[FileData] = []

# check save file, if have, load that, enable continue
func _ready():
	print("GameManager is online!")

# add more checks, mainly prevent bad language, return bool
func register_player(username: String, email: String) -> void:
	_player_name = username
	_player_email = email + _COMPANY_DOMAIN


# Player Inventory
func get_player_inventory() -> Array[FileData]:
	return _inventory.duplicate(true)


func add_file_to_inventory(file: FileData) -> bool:
	if _inventory.size() >= _MAX_INVENTORY_SIZE:
		inventory_full.emit()
		return false
	
	var new_file := file.duplicate()
	new_file.file_context = FileData.FileContext.INVENTORY
	_inventory.append(new_file)
	inventory_changed.emit(_inventory.duplicate())
	
	debug()
	return true


func change_inventory_to_outbound(file: FileData) -> FileData:
	var new_file := file.duplicate()
	new_file.file_context = FileData.FileContext.OUTBOUND
	return new_file


func move_inventory_to_trash(file: FileData) -> void:
	_inventory.erase(file)
	
	var new_file := file.duplicate()
	new_file.file_context = FileData.FileContext.TRASH
	_recycling_bin.append(new_file)
	recycling_bin_changed.emit(_recycling_bin.duplicate(true))
	
	debug()


func empty_recycling_bin() -> void:
	_recycling_bin.clear()
	recycling_bin_changed.emit(_recycling_bin.duplicate(true))
	
	debug()


func debug() -> void:
	print("Player Inventory: ", _inventory)
	print("Recycling Bin: ", _recycling_bin)


# Email Body
func replace_placeholder_name(placeholder_name: String) -> String:
	var replaced_name = placeholder_name.replace(_PLACEHOLDER_NAME, _player_name)
	return replaced_name


func replace_placeholder_email(placeholder_email: String) -> String:
	var replaced_email = placeholder_email.replace(_PLACEHOLDER_EMAIL, _player_email)
	return replaced_email


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
