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


func get_files_for_save(files: Array[FileData]) -> Array:
	var result := []
	for file in files:
		result.append(file.get_save_data())
	print(result)
	return result


# Player Inventory
func get_player_inventory() -> Array[FileData]:
	return _inventory.duplicate(true)

func is_inventory_full() -> bool:
	return _inventory.size() >= _MAX_INVENTORY_SIZE

func commit_add_to_inventory(file: FileData) -> bool:
	if is_inventory_full():
		inventory_full.emit()
		return false
	
	_inventory.append(file)
	inventory_changed.emit(_inventory.duplicate(true))
	return true

func commit_inventory_to_trash(inventory_file: FileData, trash_file: FileData) -> void:
	_inventory.erase(inventory_file)
	_recycling_bin.append(trash_file)
	
	inventory_changed.emit(_inventory.duplicate(true))
	recycling_bin_changed.emit(_recycling_bin.duplicate(true))

func commit_trash_to_inventory(trash_file: FileData, inventory_file: FileData) -> bool:
	if is_inventory_full():
		inventory_full.emit()
		return false
	
	_recycling_bin.erase(trash_file)
	_inventory.append(inventory_file)
	
	recycling_bin_changed.emit(_recycling_bin.duplicate(true))
	inventory_changed.emit(_inventory.duplicate(true))
	return true

func empty_recycling_bin() -> void:
	_recycling_bin.clear()
	recycling_bin_changed.emit(_recycling_bin.duplicate(true))

func corrupt_random_inventory_file(source_malware: FileData) -> bool:
	if _inventory.is_empty():
		return false
		
	var candidates := []
	for file in _inventory:
		if file.file_type == FileData.FileType.LEGIT:
			candidates.append(file)
		
	if candidates.is_empty():
		return false
		
	var victim: FileData = candidates.pick_random()
	_inventory.erase(victim)
	
	var cloned_malware := source_malware.duplicate(true)
	_inventory.append(cloned_malware)
	
	inventory_changed.emit(_inventory.duplicate(true))
	return true


# Email Body
func replace_placeholder_name(placeholder_name: String) -> String:
	var replaced_name = placeholder_name.replace(_PLACEHOLDER_NAME, _player_name)
	return replaced_name

func replace_placeholder_email(placeholder_email: String) -> String:
	var replaced_email = placeholder_email.replace(_PLACEHOLDER_EMAIL, _player_email)
	return replaced_email
