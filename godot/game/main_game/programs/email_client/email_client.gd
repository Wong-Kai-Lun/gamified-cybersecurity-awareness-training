extends Control

@onready var incoming_email_vbox: VBoxContainer = $ProgramVBox/EmailClientPanelContainer/HBoxContainer/IncomingEmail/ScrollContainer/MarginContainer/IncomingEmailVBox
@onready var incoming_email: PackedScene = preload("res://game/main_game/programs/email_client/incoming_email.tscn")
@onready var email_pack: EmailPack = preload("res://data/monday.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_email_pack(email_pack)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_pressed() -> void:
	# Debug only, display settings or pause menu when clicked.
	get_tree().change_scene_to_file("res://game/level_select/level_select.tscn")


func load_email_pack(pack: EmailPack) -> void:
	for email_data in pack.emails:
		var incoming_email_instance := incoming_email.instantiate()
		incoming_email_vbox.add_child(incoming_email_instance)
		incoming_email_instance.setup(email_data)

# receive signal to load email body
