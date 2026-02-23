extends PanelContainer
class_name BaseGameOverPanel


func _on_restart_day_button_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/main_menu/main_menu.tscn")
