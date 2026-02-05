extends FileWindow
class_name InventoryWindow


func _ready() -> void:
	super._ready()
	GameManagerInstance.inventory_changed.connect(draw_files)
