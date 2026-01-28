extends Control

@onready var programs_container: Control = $DesktopBG/Desktop/ProgramsContainer
@onready var email_client_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_client.tscn")
@onready var inventory_scene: PackedScene = preload("res://game/main_game/programs/inventory/inventory.tscn")
@onready var settings_scene: PackedScene = preload("res://game/main_game/programs/settings/settings.tscn")

@onready var canvas_layer = $CanvasLayer
@onready var email_client = email_client_scene.instantiate()
@onready var settings = settings_scene.instantiate()
@onready var inventory = inventory_scene.instantiate()

@onready var notif_vbox: VBoxContainer = $CanvasLayer/PanelContainer/MarginContainer/NotificationVBox
@onready var notif_toast_scene: PackedScene = preload("res://game/notification_system/notification_toast.tscn")


func _ready() -> void:
	programs_container.add_child(email_client)
	programs_container.add_child(inventory)
	inventory.hide()
	canvas_layer.add_child(settings)
	settings.hide()
	NotificationManagerInstance.request_notification.connect(_create_notif)


func _on_settings_pressed() -> void:
	settings.visible = !settings.visible

func _on_3mail_pressed() -> void:
	email_client.visible = !email_client.visible

func _on_inventory_pressed() -> void:
	inventory.visible = !inventory.visible

# Notification System



func _create_notif(data) -> void:
	var new_notif = notif_toast_scene.instantiate()
	notif_vbox.add_child(new_notif)
	new_notif.setup(data)
	new_notif.request_close.connect(_remove_notif)


func _remove_notif(notif) -> void:
	var start_x : float = notif.global_position.x
	var t := create_tween()
	
	t.set_parallel(true)
	t.tween_property(notif, "modulate:a", 0.0, 0.2)
	t.tween_property(notif, "global_position:x", start_x - 50, 0.2)
	
	t.set_parallel(false)
	t.tween_callback(notif.queue_free)
