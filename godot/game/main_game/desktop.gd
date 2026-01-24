extends Control

@onready var programs_container: Control = $DesktopBG/Desktop/ProgramsContainer
@onready var email_client_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_client.tscn")
@onready var inventory_scene: PackedScene = preload("res://game/main_game/programs/inventory/inventory.tscn")
@onready var settings_scene: PackedScene = preload("res://game/main_game/programs/settings/settings.tscn")

@onready var canvas_layer = $CanvasLayer
@onready var email_client = email_client_scene.instantiate()
@onready var settings = settings_scene.instantiate()
@onready var inventory = inventory_scene.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	programs_container.add_child(email_client)
	programs_container.add_child(inventory)
	inventory.hide()
	
	canvas_layer.add_child(settings)
	settings.hide()


func _on_settings_pressed() -> void:
	settings.visible = !settings.visible


func _on_3mail_pressed() -> void:
	email_client.visible = !email_client.visible


func _on_inventory_pressed() -> void:
	inventory.visible = !inventory.visible
