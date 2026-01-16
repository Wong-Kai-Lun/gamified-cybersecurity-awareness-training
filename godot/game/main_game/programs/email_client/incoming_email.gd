extends Control

@onready var sender_label: RichTextLabel = $PanelContainer/Open/MarginContainer/VBoxContainer/SenderNameRTL
@onready var subject_label: Label = $PanelContainer/Open/MarginContainer/VBoxContainer/SubjectLbl
@onready var body_preview_label: Label = $PanelContainer/Open/MarginContainer/VBoxContainer/BodyPreviewLbl

var email_data: EmailData

func setup(data: EmailData) -> void:
	email_data = data
	
	sender_label.text = "[b]" + data.sender_name
	subject_label.text = data.subject
	body_preview_label.text = data.email_body


func _on_open_pressed() -> void:
	pass # Replace with function body.
