extends Control

signal opened(email_data: EmailData)

@onready var bg_panel_container: PanelContainer = $Background
@onready var sender_label: RichTextLabel = $Background/Open/MarginContainer/VBoxContainer/SenderNameRTL
@onready var subject_label: Label = $Background/Open/MarginContainer/VBoxContainer/SubjectLbl
@onready var body_preview_label: RichTextLabel = $Background/Open/MarginContainer/VBoxContainer/BodyPreviewRTL

var email_data: EmailData

func setup(data: EmailData) -> void:
	email_data = data
	sender_label.text = "[b]" + data.sender_name
	subject_label.text = data.subject
	var modified_body_text = EmailServiceInstance.replace_placeholder_name(data.email_body)
	body_preview_label.text = modified_body_text
	_update_background()


func _update_status_to_read() -> void:
	email_data.flags["read"] = true


func _update_background() -> void:
	if email_data.is_important:
		var new_stylebox = StyleBoxFlat.new()
		new_stylebox.bg_color = Color(0.88, 0.79, 0.44, 1)
		bg_panel_container.add_theme_stylebox_override("panel", new_stylebox)
	
	if email_data.flags["read"]:
		var new_stylebox = StyleBoxFlat.new()
		new_stylebox.bg_color = Color(0.6, 0.6, 0.6, 1)
		bg_panel_container.add_theme_stylebox_override("panel", new_stylebox)
		
	if email_data.is_important and email_data.flags["read"]:
		var new_stylebox = StyleBoxFlat.new()
		new_stylebox.bg_color = Color(0.78, 0.69, 0.34, 1)
		bg_panel_container.add_theme_stylebox_override("panel", new_stylebox)


func _on_open_pressed() -> void:
	await EventServiceInstance.delay_input()
	opened.emit(email_data)
	_update_status_to_read()
	_update_background()
