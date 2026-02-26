extends BaseWindow
class_name SettingsWindow

signal settings_window_closed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


func on_close_requested() -> void:
	settings_window_closed.emit()


func _on_button_pressed() -> void:
	EventServiceInstance.stop()
	# add save game function here
	get_tree().change_scene_to_file("res://game/main_menu/main_menu.tscn")
	SaveloadServiceInstance.save_game()
