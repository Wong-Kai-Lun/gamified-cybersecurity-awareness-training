extends Node
class_name FileService


func convert_file_context(file: FileData, context: FileData.FileContext) -> FileData:
	var new_file := file.duplicate()
	new_file.file_context = context
	return new_file


# Create a copy from inbound to inventory
func try_add_to_inventory(file: FileData) -> bool:
	var inventory_file := convert_file_context(file, FileData.FileContext.INVENTORY)
	return GameManagerInstance.commit_add_to_inventory(inventory_file)


func move_inventory_to_trash(file: FileData) -> void:
	var trash_file := convert_file_context(file, FileData.FileContext.TRASH)
	GameManagerInstance.commit_inventory_to_trash(file, trash_file)


func move_trash_to_inventory(file: FileData) -> bool:
	var restored_file := convert_file_context(file, FileData.FileContext.INVENTORY)
	return GameManagerInstance.commit_trash_to_inventory(file, restored_file)
