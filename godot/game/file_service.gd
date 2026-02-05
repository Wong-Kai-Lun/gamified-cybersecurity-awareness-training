extends Node
class_name FileService


func convert_file_context(file: FileData, context: FileData.FileContext) -> FileData:
	var new_file := file.duplicate()
	new_file.file_context = context
	return new_file


# Create a copy from inbound to inventory
func try_add_to_inventory(file: FileData) -> bool:
	if GameManagerInstance.get_inventory_size() >= GameManagerInstance.MAX_INVENTORY_SIZE:
		GameManagerInstance.inventory_full.emit()
		return false
	
	var inventory_file = convert_file_context(file, FileData.FileContext.INVENTORY)
	GameManagerInstance.commit_add_to_inventory(inventory_file)
	return true


# add more
