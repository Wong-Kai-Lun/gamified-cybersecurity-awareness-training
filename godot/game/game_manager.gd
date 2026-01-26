extends Node
class_name GameManager

signal inventory_changed(inventory: Array[FileData])

var _inventory: Array[FileData] = []
var _recycle_bin: Array[FileData] = []

func _ready():
	print("GameManager is online!")

func add_file_to_inventory(file: FileData) -> void:
	var new_file := file.duplicate()
	new_file.file_context = FileData.FileContext.INVENTORY
	_inventory.append(new_file)
	inventory_changed.emit(_inventory.duplicate())

func change_inventory_to_outbound(file: FileData) -> FileData:
	var new_file := file.duplicate()
	new_file.file_context = FileData.FileContext.OUTBOUND
	return new_file

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
