extends Control

@onready var sender_label: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/SenderNameRTL
@onready var subject_label: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/SubjectLineRTL
@onready var body_preview_label: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/BodyPreviewRTL

var email_data: EmailData

func setup(data: EmailData) -> void:
	email_data = data
	
	sender_label.text = "[b]" + data.sender_name
	subject_label.text = data.subject
	body_preview_label.text = data.email_body
