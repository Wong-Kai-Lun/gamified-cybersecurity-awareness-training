extends BaseWindow

# ! Level Data change to set pack from selection, Game Manager !
@onready var email_pack: EmailPack = preload("res://data/monday.tres")

# Incoming Email Chips
@onready var incoming_email_vbox: VBoxContainer = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/IncomingEmail/ScrollContainer/MarginContainer/IncomingEmailVBox
@onready var incoming_email: PackedScene = preload("res://game/main_game/programs/email_client/incoming_email.tscn")

# Email Body
@onready var email_body_container: PanelContainer = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/EmailBodyContainer

@onready var base_email_body: PackedScene = preload("res://game/main_game/programs/email_client/email_body/email_body_base.tscn")
@onready var base_email_body_obj := base_email_body.instantiate()

@onready var inbound_email_body: PackedScene = preload("res://game/main_game/programs/email_client/inbound/email_body_inbound.tscn")
@onready var inbound_email_body_obj := inbound_email_body.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	load_email_pack(email_pack)
	
	email_body_container.add_child(base_email_body_obj)
	email_body_container.add_child(inbound_email_body_obj)
	base_email_body_obj.hide()
	inbound_email_body_obj.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


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
		if child.has_method("hide"):
			child.hide()
		
	var email_type = email_data.email_type
	# instantiate base, inbound and outbound once, just call setup when change
	match email_type:
		"message":
			base_email_body_obj.setup(email_data)
			print("Base Email Setup Called")
			base_email_body_obj.show()
		"download":
			inbound_email_body_obj.setup(email_data)
			print("Inbound Email Setup Called")
			inbound_email_body_obj.show()
