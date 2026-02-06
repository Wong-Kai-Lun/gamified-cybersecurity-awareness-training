extends BaseWindow
class_name EmailClientWindow

# ! Level Data change to set pack from selection, Game Manager !
@onready var email_pack: EmailPack = preload("res://data/email_pack/monday.tres")

# Incoming Email Chips
@onready var incoming_email_vbox: VBoxContainer = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/IncomingEmail/ScrollContainer/MarginContainer/IncomingEmailVBox
@onready var incoming_email: PackedScene = preload("res://game/main_game/programs/email_client/incoming_email.tscn")

# Email Body
@onready var email_body_container: PanelContainer = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/EmailBodyContainer
@onready var email_body_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_body/email_body.tscn")
@onready var email_body_obj := email_body_scene.instantiate()
@onready var input_blocker: Label = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/EmailBodyContainer/InputBlocker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	load_email_pack(email_pack)
	
	email_body_container.add_child(email_body_obj)
	input_blocker.move_to_front()
	
	email_body_obj.hide()
	input_blocker.hide()


func load_email_pack(pack: EmailPack) -> void:
	for email_data in pack.emails:
		var incoming_email_instance := incoming_email.instantiate()
		incoming_email_vbox.add_child(incoming_email_instance)
		incoming_email_instance.setup(email_data)
		incoming_email_instance.opened.connect(_on_email_selected)


# later add change mail status from unread to read and change its colors
# a reported email has everything inside it disabled
func _on_email_selected(data: EmailData) -> void:
	email_body_obj.setup(data)
	email_body_obj.show()
	input_blocker.hide()
	
	if data.is_reported:
		input_blocker.show()
