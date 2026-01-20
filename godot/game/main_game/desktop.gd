extends Control

@onready var current_program: Control = $DesktopBG/Desktop/CurrentProgram
@onready var canvas_layer = $CanvasLayer
@onready var email_client_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_client.tscn")
@onready var settings_scene: PackedScene = preload("res://game/main_game/programs/settings/settings.tscn")
@onready var inventory_scene: PackedScene = preload("res://game/main_game/programs/inventory/inventory.tscn")

@onready var email_client = email_client_scene.instantiate()
@onready var settings = settings_scene.instantiate()
@onready var inventory = inventory_scene.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_program.add_child(email_client)
	
	canvas_layer.add_child(settings)
	settings.hide()
	
	canvas_layer.add_child(inventory)
	inventory.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# change to preload and hide settings and inventory and show when clicked instead of destroy
func _on_settings_pressed() -> void:
	if settings.visible:
		return
	settings.show()


func _on_3mail_pressed() -> void:
	if email_client.visible:
		return
	email_client.show()


func _on_inventory_pressed() -> void:
	if inventory.visible:
		return
	inventory.show()
