extends BaseWindow
class_name NewPlayerWindow

signal start_pressed(username, email)
signal new_player_window_closed

@onready var username_input: LineEdit = $WindowPanel/Structure/Content/MarginContainer/VBoxContainer/UsernameVBox/UsernameInput
@onready var email_input: LineEdit = $WindowPanel/Structure/Content/MarginContainer/VBoxContainer/EmailVBox/HBoxContainer/EmailInput
@onready var start_button: Button = $WindowPanel/Structure/Content/MarginContainer/VBoxContainer/StartButton

func _ready() -> void:
	super._ready()
	_on_line_edit_text_changed(username_input.text)
	_on_line_edit_text_changed(email_input.text)
	username_input.text_changed.connect(_on_line_edit_text_changed)
	email_input.text_changed.connect(_on_line_edit_text_changed)


func _on_line_edit_text_changed(new_text: String) -> void:
	var is_username_empty = username_input.text.strip_edges().is_empty()
	var is_email_empty = email_input.text.strip_edges().is_empty()
	start_button.disabled = is_username_empty or is_email_empty
	#insert regex logic here?

func on_close_requested() -> void:
	new_player_window_closed.emit()


func _on_start_button_pressed() -> void:
	var username: String = username_input.text
	var email: String = email_input.text
	start_pressed.emit(username, email)
