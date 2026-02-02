extends BaseWindow
class_name NewPlayerWindow

signal start_pressed(username, email)
signal new_player_window_closed

@onready var username_input: LineEdit = $WindowPanel/Structure/Content/MarginContainer/VBoxContainer/UsernameVBox/UsernameInput
@onready var email_input: LineEdit = $WindowPanel/Structure/Content/MarginContainer/VBoxContainer/EmailVBox/HBoxContainer/EmailInput


func _ready() -> void:
	super._ready()
	#close_pressed.connect(_on_base_close_pressed)


func on_close_requested() -> void:
	new_player_window_closed.emit()
	print("On base close triggered")


func _on_start_button_pressed() -> void:
	var username: String = username_input.text
	var email: String = email_input.text
	start_pressed.emit(username, email)
