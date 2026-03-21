extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var new_player_window_scene: PackedScene = preload("res://game/main_menu/new_player_window.tscn")
@onready var new_player_window = new_player_window_scene.instantiate()
@onready var input_blocker_scene: PackedScene = preload("res://game/main_game/programs/common/input_blocker.tscn")
@onready var input_blocker = input_blocker_scene.instantiate()
@onready var continue_button = $HBoxContainer/MarginContainer/BaseWindow/MarginContainer/VBoxContainer/ButtonContainer/Continue
@onready var leaderboard_grid = $HBoxContainer/Scoreboard/PanelContainer/LeaderboardVBox/PlayerScores


func _ready() -> void:
	canvas_layer.add_child(input_blocker)
	canvas_layer.add_child(new_player_window)
	input_blocker.hide()
	new_player_window.hide()
	new_player_window.start_pressed.connect(_register_player_and_start)
	new_player_window.new_player_window_closed.connect(_on_new_player_window_closed)
	
	if FileAccess.file_exists("user://save_file.json"):
		continue_button.disabled = false
	
	NetworkManagerInstance.leaderboard_received.connect(_update_leaderboard)
	NetworkManagerInstance.get_leaderboard()


func _register_player_and_start(username: String, email: String) -> void:
	GameManagerInstance.register_player(username, email)
	GameManagerInstance.start_new_game()
	get_tree().change_scene_to_file("res://game/main_game/desktop.tscn")


func _update_leaderboard(leaderboard: Array):
	var leaderboard_label_scene: PackedScene = load("res://game/main_menu/leaderboard_label.tscn")
	
	for child in leaderboard_grid.get_children():
		child.queue_free()
	
	for player_info in leaderboard:
		var player_name = leaderboard_label_scene.instantiate()
		player_name.text = player_info["player_name"]
		leaderboard_grid.add_child(player_name)
		
		var score = leaderboard_label_scene.instantiate()
		score.text = str(player_info["score"])
		leaderboard_grid.add_child(score)


func _on_new_game_pressed() -> void:
	input_blocker.show()
	new_player_window.open()


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
