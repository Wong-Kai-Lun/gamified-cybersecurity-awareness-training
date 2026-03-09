@tool
extends Control
class_name TitleBar

signal close_pressed
var _title := ""
@onready var close_button: Button = $MarginContainer/TitleBarContainer/CloseButton

signal drag_started(offset: Vector2)
signal drag_ended

@export var title: String:
	set(value):
		_title = value
		
		var title_lbl := get_node_or_null("MarginContainer/TitleBarContainer/Title")
		if title_lbl:
			title_lbl.text = value
	get:
		return _title


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var title_lbl := get_node_or_null("MarginContainer/TitleBarContainer/Title")
	if title_lbl:
		title_lbl.text = _title


func _on_close_button_pressed() -> void:
	close_pressed.emit()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("drag_started", event.position)
		else:
			emit_signal("drag_ended")
