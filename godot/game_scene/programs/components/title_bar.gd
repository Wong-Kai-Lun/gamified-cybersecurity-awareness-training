@tool
extends Control
class_name TitleBar

signal close_pressed

@export var title: String:
	set(value):
		title = value
		if has_node("PanelContainer/TitleBarContainer/MarginContainer/Title"):
			$PanelContainer/TitleBarContainer/MarginContainer/Title.text = value
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	emit_signal("close_pressed")
