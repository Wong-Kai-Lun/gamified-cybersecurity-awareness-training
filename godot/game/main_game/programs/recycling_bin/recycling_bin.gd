extends FileWindow
class_name RecyclingBinWindow


func _ready() -> void:
	super._ready()
	FileServiceInstance.recycling_bin_changed.connect(draw_files)


func _on_empty_bin_button_pressed() -> void:
	FileServiceInstance.empty_recycling_bin()
