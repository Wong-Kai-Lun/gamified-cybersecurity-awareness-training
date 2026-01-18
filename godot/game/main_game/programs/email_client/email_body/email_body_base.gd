extends Control

@onready var subject: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/SubjectRTL
@onready var from_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/FromSection/FromRTL
@onready var to_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/ToSection/ToRTL
@onready var cc_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/CCSection/CCRTL
@onready var body_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BodyRTL

var email_data: EmailData

func _ready() -> void:
	subject.bbcode_enabled = true
	body_rtl.bbcode_enabled = true

func setup(data: EmailData) -> void:
	email_data = data
	
	subject.append_text("[b]" + data.subject)
	from_rtl.text = data.sender_address
	to_rtl.text = "player@abc.com.my"
	cc_rtl.text = data.cc_address
	body_rtl.append_text(data.email_body)
