extends Control
class_name BaseWindow

@onready var title_bar: Control = $WindowPanel/Structure/TitleBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_bar.close_pressed.connect(_hide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _hide() -> void:
	self.hide()
