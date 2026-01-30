extends Control

signal opened(email_data: EmailData)

@onready var bg_panel_container: PanelContainer = $Background
@onready var sender_label: RichTextLabel = $Background/Open/MarginContainer/VBoxContainer/SenderNameRTL
@onready var subject_label: Label = $Background/Open/MarginContainer/VBoxContainer/SubjectLbl
@onready var body_preview_label: Label = $Background/Open/MarginContainer/VBoxContainer/BodyPreviewLbl

enum ReadStatus { UNREAD, READ, IMPORTANT }

var email_data: EmailData
var _read_status: ReadStatus = ReadStatus.UNREAD

func setup(data: EmailData) -> void:
	email_data = data
	sender_label.text = "[b]" + data.sender_name
	subject_label.text = data.subject
	body_preview_label.text = data.email_body


func _update_status_to_read() -> void:
	_read_status = ReadStatus.READ


func _darken_background() -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = Color(0.7, 0.7, 0.7, 1)
	bg_panel_container.add_theme_stylebox_override("panel", new_stylebox)


func _on_open_pressed() -> void:
	opened.emit(email_data)
	_update_status_to_read()
	_darken_background()
