extends Control
class_name BaseEmailBody

@onready var subject: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/SubjectRTL
@onready var from_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/FromSection/FromRTL
@onready var to_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/ToSection/ToRTL
@onready var cc_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/CCSection/CCRTL
@onready var body_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BodyRTL
@onready var menu_btn: MenuButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MenuButton
@onready var attachment_slot: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/AttachmentSlot

@onready var inbound_container_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_body/inbound_file_container.tscn")
@onready var inbound_container_instance = inbound_container_scene.instantiate()

@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")


var email_data: EmailData

func _ready() -> void:
	subject.bbcode_enabled = true
	body_rtl.bbcode_enabled = true
	
	attachment_slot.add_child(inbound_container_instance)
	inbound_container_instance.hide()
	
	menu_setup()

func setup(data: EmailData) -> void:
	email_data = data
	
	subject.bbcode_text = "[b]" + data.subject
	from_rtl.text = data.sender_address
	to_rtl.text = data.to_address
	cc_rtl.text = data.cc_address
	body_rtl.bbcode_text = data.email_body
	
	inbound_container_instance.hide()
	
	
func setup_inbound(email_data: EmailData) -> void:
	var file_array = email_data.attached_files
	
	for file_data in file_array:
		var file_instance := file_scene.instantiate()
		inbound_container_instance.add_child(file_instance)
		file_instance.setup(file_data)
	
	if !inbound_container_instance.visible:
		inbound_container_instance.show()


func menu_setup() -> void:
	var pop_up_menu: PopupMenu = menu_btn.get_popup()
	pop_up_menu.add_item("Report phishing", 0)
	pop_up_menu.id_pressed.connect(_on_report_pressed)


# work on this later
func _on_report_pressed(id: int) -> void:
	match id:
		0:
			print("Report Button Pressed!")
