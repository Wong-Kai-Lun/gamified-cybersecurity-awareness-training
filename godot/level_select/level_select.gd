extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_monday_pressed() -> void:
	print("The level Monday has been selected.")
	get_tree().change_scene_to_file("res://game_scene/game_scene.tscn")
	# create base game interface then load later


func _on_tuesday_pressed() -> void:
	print("The level Tuesday has been selected.")


func _on_wednesday_pressed() -> void:
	print("The level Wednesday has been selected.")


func _on_thursday_pressed() -> void:
	print("The level Thursday has been selected.")


func _on_friday_pressed() -> void:
	print("The level Friday has been selected.")
