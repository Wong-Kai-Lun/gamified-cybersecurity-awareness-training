@tool
extends Control
class_name TitleBar

signal close_pressed
var _title := ""

signal drag_started(offset: Vector2)
signal drag_ended

@export var title: String:
	set(value):
		_title = value
		
		var title_lbl := get_node_or_null("PanelContainer/TitleBarContainer/MarginContainer/Title")
		if title_lbl:
			title_lbl.text = value
	get:
		return _title


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var title_lbl := get_node_or_null("PanelContainer/TitleBarContainer/MarginContainer/Title")
	if title_lbl:
		title_lbl.text = _title


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	emit_signal("close_pressed")


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("drag_started", event.position)
			
		else:
			emit_signal("drag_ended")
