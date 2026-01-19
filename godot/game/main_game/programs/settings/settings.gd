extends Control
class_name Settings

@onready var title_bar: Control = $WindowPanel/Structure/TitleBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_bar.close_pressed.connect(_hide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/level_select/level_select.tscn")


func _hide() -> void:
	self.hide()
