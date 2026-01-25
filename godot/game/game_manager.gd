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
