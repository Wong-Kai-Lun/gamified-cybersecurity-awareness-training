extends Control

@onready var settings_scene: PackedScene = preload("res://game/main_game/programs/settings/settings.tscn")
@onready var canvas_layer = $CanvasLayer
@onready var settings = settings_scene.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.add_child(settings)
	settings.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# change to preload and hide settings and inventory and show when clicked instead of destroy
func _on_settings_pressed() -> void:
	if settings.visible:
		return
	settings.show()
