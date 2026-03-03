extends BaseWindow
class_name SettingsWindow

signal settings_window_closed
signal game_exited


func _ready() -> void:
	super._ready()


func on_close_requested() -> void:
	settings_window_closed.emit()


func _on_button_pressed() -> void:
	game_exited.emit()
