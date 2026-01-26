extends Control
class_name EmailBody

@onready var subject: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/SubjectRTL
@onready var from_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/FromSection/FromRTL
@onready var to_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/ToSection/ToRTL
@onready var cc_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Header/CCSection/CCRTL
@onready var body_rtl: RichTextLabel = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/BodyRTL
@onready var menu_btn: MenuButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MenuButton
@onready var attachment_slot: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/AttachmentSlot

@onready var inbound_file_container_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_body/inbound_file_container.tscn")
@onready var inbound_file_container_instance = inbound_file_container_scene.instantiate()

@onready var outbound_file_container_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_body/outbound_file_container.tscn")
@onready var outbound_file_container_instance = outbound_file_container_scene.instantiate()
@onready var send_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Send

@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")

var email_data: EmailData


func _ready() -> void:
	subject.bbcode_enabled = true
	body_rtl.bbcode_enabled = true
	
	attachment_slot.add_child(inbound_file_container_instance)
	inbound_file_container_instance.hide()
	
	attachment_slot.add_child(outbound_file_container_instance)
	outbound_file_container_instance.hide()
	send_button.hide()
	
	_menu_setup() # work on it later


func setup(data: EmailData) -> void:
	var email_type = data.email_type
	
	match email_type:
		data.EmailType.MESSAGE:
			self._setup_message(data)
			
		data.EmailType.INBOUND:
			self._setup_inbound(data)
			
		data.EmailType.OUTBOUND:
			self._setup_outbound(data)
		
		_:
			push_warning("Unhandled EmailType: %s" % data.email_type)


func _setup_message(data: EmailData) -> void:
	email_data = data
	
	subject.bbcode_text = "[b]" + data.subject
	from_rtl.text = data.sender_address
	to_rtl.text = data.to_address
	cc_rtl.text = data.cc_address
	body_rtl.bbcode_text = data.email_body
	
	inbound_file_container_instance.hide()
	outbound_file_container_instance.hide()
	send_button.hide()


func _setup_inbound(data: EmailData) -> void:
	_setup_message(data)
	inbound_file_container_instance.clear_files()
	inbound_file_container_instance.populate(data.attached_files)
	inbound_file_container_instance.show()


# Update it to show a drop zone arrow icon in can_drop_data func
func _setup_outbound(data: EmailData) -> void:
	_setup_message(data)
	outbound_file_container_instance.clear_files()
	outbound_file_container_instance.show()
	send_button.show()


func _menu_setup() -> void:
	var pop_up_menu: PopupMenu = menu_btn.get_popup()
	pop_up_menu.add_item("Report phishing", 0)
	pop_up_menu.id_pressed.connect(_on_report_pressed)


func _on_send_pressed() -> void:
	var attached_files = outbound_file_container_instance.get_outbound_array()
	GameManagerInstance.validate_outbound_files(email_data, attached_files)


# lock email after report
func _on_report_pressed(id: int) -> void:
	match id:
		0:
			print("Report Button Pressed!")
