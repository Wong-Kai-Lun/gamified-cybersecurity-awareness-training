extends Control

@onready var settings_scene: PackedScene = preload("res://game/main_game/programs/settings/settings.tscn")
@onready var settings_spawn = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_settings_pressed() -> void:
	var settings = settings_scene.instantiate()
	settings_spawn.add_child(settings)
