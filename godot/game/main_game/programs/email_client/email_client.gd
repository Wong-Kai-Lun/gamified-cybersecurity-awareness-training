extends BaseWindow
class_name EmailClientWindow

# ! Level Data change to set pack from selection, Game Manager !
@onready var email_pack: EmailPack = preload("res://data/email_pack/monday.tres")

# Incoming Email Chips
@onready var incoming_email_vbox: VBoxContainer = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/IncomingEmail/ScrollContainer/MarginContainer/IncomingEmailVBox
@onready var incoming_email: PackedScene = preload("res://game/main_game/programs/email_client/incoming_email.tscn")

# Email Body
@onready var email_body_container: PanelContainer = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/EmailBodyContainer

@onready var base_email_body: PackedScene = preload("res://game/main_game/programs/email_client/email_body/email_body_base.tscn")
@onready var base_email_body_obj := base_email_body.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	load_email_pack(email_pack)
	
	email_body_container.add_child(base_email_body_obj)
	base_email_body_obj.hide()


func load_email_pack(pack: EmailPack) -> void:
	for email_data in pack.emails:
		var incoming_email_instance := incoming_email.instantiate()
		incoming_email_vbox.add_child(incoming_email_instance)
		incoming_email_instance.setup(email_data)
		incoming_email_instance.opened.connect(_on_email_selected)

# later add change mail status from unread to read and change its colors
# a reported email has everything inside it disabled
func _on_email_selected(email_data: EmailData) -> void:
	for child in email_body_container.get_children():
		child.hide()

	var email_type = email_data.email_type
	# instantiate base, inbound and outbound once, just call setup when change
	match email_type:
		
		email_data.EmailType.MESSAGE:
			base_email_body_obj.setup(email_data)
			base_email_body_obj.show()
			
		email_data.EmailType.INBOUND:
			base_email_body_obj.setup(email_data)
			base_email_body_obj.setup_inbound(email_data)
			base_email_body_obj.show()
