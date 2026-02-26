extends Control

@onready var programs_container: Control = $DesktopBG/Desktop/ProgramsContainer
@onready var email_client_scene: PackedScene = preload("res://game/main_game/programs/email_client/email_client.tscn")
@onready var inventory_scene: PackedScene = preload("res://game/main_game/programs/inventory/inventory.tscn")
@onready var settings_scene: PackedScene = preload("res://game/main_game/programs/settings/settings.tscn")
@onready var recycling_bin_scene: PackedScene = preload("res://game/main_game/programs/recycling_bin/recycling_bin.tscn")

@onready var canvas_layer = $CanvasLayer
@onready var email_client = email_client_scene.instantiate()
@onready var settings = settings_scene.instantiate()
@onready var inventory = inventory_scene.instantiate()
@onready var recycling_bin = recycling_bin_scene.instantiate()

@onready var input_blocker_scene: PackedScene = preload("res://game/main_game/programs/common/input_blocker.tscn")
@onready var input_blocker = input_blocker_scene.instantiate()

@onready var notif_vbox: VBoxContainer = $CanvasLayer/NotificationPanel/MarginContainer/ScrollContainer/NotificationVBox
@onready var notif_toast_scene: PackedScene = preload("res://game/notification_system/notification_toast.tscn")

@onready var transition_bg: ColorRect = $CanvasLayer/TransitionPanel/ColorRect
@onready var transition_lbl: Label = $CanvasLayer/TransitionPanel/Label

func _ready() -> void:
	_initialise_level()
	
	NotificationManagerInstance.request_notification.connect(_create_notif)
	EventServiceInstance.game_over.connect(_on_game_over)
	EventServiceInstance.adware_triggered.connect(_on_adware_triggered)
	EventServiceInstance.ransomware_downloaded.connect(_flash_cmd_window)


func _on_settings_pressed() -> void:
	if settings.visible:
		settings.close()
	else:
		settings.open()
	input_blocker.visible = !input_blocker.visible

func _on_settings_closed() -> void:
	input_blocker.hide()


func _on_3mail_pressed() -> void:
	await EventServiceInstance.delay_input()
	if email_client.visible:
		email_client.close()
	else:
		email_client.open()


func _on_inventory_pressed() -> void:
	await EventServiceInstance.delay_input()
	if inventory.visible:
		inventory.close()
	else:
		inventory.open()


func _on_trash_pressed() -> void:
	await EventServiceInstance.delay_input()
	if recycling_bin.visible:
		recycling_bin.close()
	else:
		recycling_bin.open()


# Level Transition
func _initialise_level() -> void:
	var programs := [email_client, inventory, recycling_bin]
	for program in programs:
		programs_container.add_child(program)
		program.close()
	
	canvas_layer.add_child(input_blocker)
	canvas_layer.add_child(settings)
	settings.settings_window_closed.connect(_on_settings_closed)
	input_blocker.hide()
	settings.close()
	
	await _animate_enter_level()
	await _wait(1.0)
	email_client.open()


func _animate_enter_level() -> void:
	var day := LevelServiceInstance.get_current_day()
	var level_name := LevelServiceInstance.get_current_level_name()
	transition_lbl.text = level_name
	
	transition_bg.show()
	transition_lbl.show()
	
	await TweenUtils.fade_in(transition_lbl, 1.0, 2.0)
	await _wait(2.0)
	TweenUtils.fade_out(transition_bg, 2.0)
	await TweenUtils.fade_out(transition_lbl, 2.0)
	
	transition_bg.hide()
	transition_lbl.hide()


# Notification System
func _create_notif(data) -> void:
	var new_notif = notif_toast_scene.instantiate()
	notif_vbox.add_child(new_notif)
	new_notif.setup(data)
	new_notif.request_close.connect(_remove_notif)
	TweenUtils.fade_in(new_notif, 1.0, 0.1)


func _remove_notif(node) -> void:
	node.close_button.disabled = true
	await TweenUtils.fade_and_slide_out(node, -50, 0.2)
	node.queue_free()


# Consequences
func _wait(duration: float) -> void:
	await get_tree().create_timer(duration).timeout


func _on_game_over(reason: EventServiceInstance.GameOverReason) -> void:
	match reason:
		EventServiceInstance.GameOverReason.OVERLOAD:
			_trigger_bsod()
		EventServiceInstance.GameOverReason.RANSOMWARE:
			_trigger_ransomware()


func _on_adware_triggered(ad_window_amount: int) -> void:
	var ad_window_scene: PackedScene = load("res://game/main_game/programs/events/ad_window.tscn")
	for ad_window in ad_window_amount:
		var ad_window_instance = ad_window_scene.instantiate()
		var container_size = programs_container.size
		
		var x = randf_range(0, container_size.x)
		var y = randf_range(0, container_size.y)
		
		ad_window_instance.visible = false
		programs_container.add_child(ad_window_instance)
		ad_window_instance.position = Vector2(x, y)
		ad_window_instance.setup()
		
		await _wait(randf_range(0.10, 0.30))
		ad_window_instance.open()


func _trigger_bsod() -> void:
	var bsod_panel_scene: PackedScene = load("res://game/main_game/programs/events/game_over/bsod_panel.tscn")
	var bsod_panel_instance = bsod_panel_scene.instantiate()
	canvas_layer.add_child(bsod_panel_instance)


func _trigger_ransomware() -> void:
	var background_img: PanelContainer = $DesktopBG
	
	var ransomware_texture: Texture2D = load("res://assets/ransomware.png")
	if ransomware_texture == null:
		push_warning("Ransomware Image not found.")
	
	var new_stylebox_texture = StyleBoxTexture.new()
	new_stylebox_texture.texture = ransomware_texture
	background_img.add_theme_stylebox_override("panel", new_stylebox_texture)
	
	email_client.close()
	inventory.close()
	recycling_bin.close()
	_show_game_over_panel()


func _flash_cmd_window() -> void:
	var cmd_window_scene: PackedScene = load("res://game/main_game/programs/events/cmd_window.tscn")
	var cmd_window_instance = cmd_window_scene.instantiate()
	programs_container.add_child(cmd_window_instance)
	cmd_window_instance.hide()
	
	await _wait(2.0)
	await cmd_window_instance.open()
	await _wait(1.0)
	await cmd_window_instance.close()


func _show_game_over_panel() -> void:
	var game_over_panel_scene: PackedScene = load("res://game/main_game/programs/events/game_over/game_over_panel.tscn")
	var game_over_panel_instance = game_over_panel_scene.instantiate()
	
	await _wait(2.0)
	canvas_layer.add_child(game_over_panel_instance)
	TweenUtils.fade_in(game_over_panel_instance, 1.0, 1.0)
