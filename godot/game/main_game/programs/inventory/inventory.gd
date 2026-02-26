extends FileWindow
class_name InventoryWindow


func _ready() -> void:
	super._ready()
	FileServiceInstance.inventory_changed.connect(draw_files)
