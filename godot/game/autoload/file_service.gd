extends Node
class_name FileService

signal inventory_changed(inventory: Array[FileData])
signal inventory_full
signal recycling_bin_changed(recycling_bin: Array[FileData])

const _MAX_INVENTORY_SIZE = 16

#region Saveable Data
var _inventory: Array[FileData] = []
var _recycling_bin: Array[FileData] = []
#endregion


# Game Start / Load Game
func reset() -> void:
	empty_inventory()
	empty_recycling_bin()


func empty_inventory() -> void:
	_inventory.clear()
	inventory_changed.emit(_inventory.duplicate(true))


func empty_recycling_bin() -> void:
	_recycling_bin.clear()
	recycling_bin_changed.emit(_recycling_bin.duplicate(true))


func get_files_for_save(array: Array[FileData]) -> Array:
	var collected_files := []
	for file in array:
		collected_files.append(file.get_save_data())
	return collected_files


func get_data_for_save() -> Dictionary:
	return {
		"inventory": get_files_for_save(_inventory),
		"recycling_bin": get_files_for_save(_recycling_bin)
	}


#region Player Inventory Mutation
func get_player_inventory() -> Array[FileData]:
	return _inventory.duplicate(true)


func is_inventory_full() -> bool:
	return _inventory.size() >= _MAX_INVENTORY_SIZE


func convert_file_context(file: FileData, context: FileData.FileContext) -> FileData:
	var new_file := file.duplicate()
	new_file.file_context = context
	return new_file


func copy_source_to_inventory(source_file: FileData) -> bool:
	if is_inventory_full():
		inventory_full.emit()
		return false
	
	var converted_file := convert_file_context(source_file, FileData.FileContext.INVENTORY)
	_inventory.append(converted_file)
	inventory_changed.emit(_inventory.duplicate(true))
	return true


func move_inventory_to_trash(inventory_file: FileData) -> void:
	var trash_file := convert_file_context(inventory_file, FileData.FileContext.TRASH)
	_inventory.erase(inventory_file)
	_recycling_bin.append(trash_file)
	inventory_changed.emit(_inventory.duplicate(true))
	recycling_bin_changed.emit(_recycling_bin.duplicate(true))


func move_trash_to_inventory(trash_file: FileData) -> bool:
	if is_inventory_full():
		inventory_full.emit()
		return false

	var restored_file := convert_file_context(trash_file, FileData.FileContext.INVENTORY)
	_recycling_bin.erase(trash_file)
	_inventory.append(restored_file)
	recycling_bin_changed.emit(_recycling_bin.duplicate(true))
	inventory_changed.emit(_inventory.duplicate(true))
	return true


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

#endregion
