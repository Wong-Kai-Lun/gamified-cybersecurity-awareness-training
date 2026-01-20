extends Control
class_name BaseEmailBody

@onready var subject: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/SubjectRTL
@onready var from_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/FromSection/FromRTL
@onready var to_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/ToSection/ToRTL
@onready var cc_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/CCSection/CCRTL
@onready var body_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BodyRTL

@onready var menu_btn: MenuButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MenuButton

var email_data: EmailData

func _ready() -> void:
	subject.bbcode_enabled = true
	body_rtl.bbcode_enabled = true
	
	var pop_up_menu: PopupMenu = menu_btn.get_popup()
	pop_up_menu.add_item("Report phishing", 0)
	pop_up_menu.id_pressed.connect(_on_report_pressed)


func setup(data: EmailData) -> void:
	email_data = data
	
	subject.bbcode_text = "[b]" + data.subject
	from_rtl.text = data.sender_address
	to_rtl.text = data.to_address
	cc_rtl.text = data.cc_address
	body_rtl.bbcode_text = data.email_body

func _on_report_pressed(id: int) -> void:
	match id:
		0:
			print("Report Button Pressed!")
