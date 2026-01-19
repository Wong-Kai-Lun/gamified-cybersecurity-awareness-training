extends Control

# Level Data change to set pack from selection, Game Manager
@onready var email_pack: EmailPack = preload("res://data/monday.tres")

# Incoming Email
@onready var incoming_email_vbox: VBoxContainer = $ProgramVBox/EmailClientPanelContainer/HBoxContainer/IncomingEmail/ScrollContainer/MarginContainer/IncomingEmailVBox
@onready var incoming_email: PackedScene = preload("res://game/main_game/programs/email_client/incoming_email.tscn")

# Email Body
@onready var email_body_container: PanelContainer = $ProgramVBox/EmailClientPanelContainer/HBoxContainer/EmailBodyContainer
@onready var email_body_base: PackedScene = preload("res://game/main_game/programs/email_client/email_body/email_body_base.tscn")
var email_body_instance: Control = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_email_pack(email_pack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	# Debug only, display settings or pause menu when clicked.
	get_tree().change_scene_to_file("res://game/level_select/level_select.tscn")


func load_email_pack(pack: EmailPack) -> void:
	for email_data in pack.emails:
		var incoming_email_instance := incoming_email.instantiate()
		incoming_email_vbox.add_child(incoming_email_instance)
		incoming_email_instance.setup(email_data)
		incoming_email_instance.opened.connect(_on_email_selected)

func _on_email_selected(email_data: EmailData) -> void:
	if email_body_instance:
		email_body_instance.queue_free()
		
	var email_body_instance := email_body_base.instantiate()
	email_body_container.add_child(email_body_instance)
	email_body_instance.setup(email_data)
