extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var new_player_window_scene: PackedScene = preload("res://game/main_menu/new_player_window.tscn")
@onready var new_player_window = new_player_window_scene.instantiate()
@onready var input_blocker_scene: PackedScene = preload("res://game/main_game/programs/common/input_blocker.tscn")
@onready var input_blocker = input_blocker_scene.instantiate()
@onready var continue_button = $HBoxContainer/MarginContainer/BaseWindow/MarginContainer/VBoxContainer/ButtonContainer/Continue


func _ready() -> void:
	canvas_layer.add_child(input_blocker)
	canvas_layer.add_child(new_player_window)
	input_blocker.hide()
	new_player_window.hide()
	new_player_window.start_pressed.connect(_register_player_and_start)
	new_player_window.new_player_window_closed.connect(_on_new_player_window_closed)
	
	if FileAccess.file_exists("user://save_file.json"):
		continue_button.disabled = false


func _register_player_and_start(username: String, email: String) -> void:
	GameManagerInstance.register_player(username, email)
	GameManagerInstance.start_new_game()
	get_tree().change_scene_to_file("res://game/main_game/desktop.tscn")


func _on_new_game_pressed() -> void:
	input_blocker.show()
	new_player_window.open()
	# Function to check if have existing save file. If no, proceed. If have, ask for confirmation.

func _on_new_player_window_closed() -> void:
	input_blocker.hide()
	new_player_window.close()


func _on_continue_pressed() -> void:
	SaveloadServiceInstance.continue_game()
	get_tree().change_scene_to_file("res://game/main_game/desktop.tscn")


func _on_settings_pressed() -> void:
	pass


func _on_quit_game_pressed() -> void:
	get_tree().quit()
