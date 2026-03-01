extends BaseWindow
class_name EmailClientWindow

# Incoming Email Chips
@onready var incoming_email_vbox: VBoxContainer = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/IncomingEmail/ScrollContainer/MarginContainer/IncomingEmailVBox
@onready var incoming_email: PackedScene = preload("res://game/main_game/programs/email_client/incoming_email.tscn")

# Email Body
@onready var email_body_container: PanelContainer = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/EmailBodyContainer
@onready var email_body_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_body/email_body.tscn")
@onready var email_body_obj := email_body_scene.instantiate()
@onready var input_blocker: Label = $WindowPanel/Structure/Content/EmailClientPanelContainer/HBoxContainer/EmailBodyContainer/InputBlocker


func _ready() -> void:
	super._ready()
	EmailServiceInstance.emails_updated.connect(_draw_emails)
	
	email_body_obj.email_reported.connect(_block_reported_email)
	email_body_container.add_child(email_body_obj)
	input_blocker.move_to_front()
	
	email_body_obj.hide()
	input_blocker.hide()


func _draw_emails(email_array: Array[EmailData]) -> void:
	_clear_emails()
	
	for email_data in email_array:
		var incoming_email_instance := incoming_email.instantiate()
		incoming_email_vbox.add_child(incoming_email_instance)
		incoming_email_instance.setup(email_data)
		incoming_email_instance.opened.connect(_on_email_selected)


func _clear_emails() -> void:
	for child in incoming_email_vbox.get_children():
		child.queue_free()


func _on_email_selected(data: EmailData) -> void:
	email_body_obj.setup(data)
	email_body_obj.show()
	_block_reported_email(data)


func _block_reported_email(data: EmailData) -> void:
	if data.flags["reported"]:
		input_blocker.show()
	else:
		input_blocker.hide()
