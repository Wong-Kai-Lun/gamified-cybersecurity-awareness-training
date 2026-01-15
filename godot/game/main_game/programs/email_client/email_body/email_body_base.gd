extends Control

@onready var subject: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/Header/SubjectRTL
@onready var from_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/Header/FromSection/FromRTL
@onready var to_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/Header/ToSection/ToRTL
@onready var cc_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/Header/CCSection/CCRTL
@onready var body_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BodyRTL

var email_data: EmailData

func setup(data: EmailData) -> void:
	email_data = data
	
	subject.text = "[b]" + data.subject
	from_rtl.text = data.sender_address
	to_rtl.text = "player@abc.com.my"
	cc_rtl.text = data.cc_address
	body_rtl.text = data.email_body
