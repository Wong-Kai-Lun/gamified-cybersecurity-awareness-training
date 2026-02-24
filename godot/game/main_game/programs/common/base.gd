extends Control
class_name BaseWindow

@onready var title_bar: Control = $WindowPanel/Structure/TitleBar

var is_dragging := false
var drag_offset := Vector2.ZERO
var _is_animating := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_bar.close_pressed.connect(_on_close_pressed)
	set_process(true)
	title_bar.connect("drag_started", Callable(self, "_on_drag_started"))
	title_bar.connect("drag_ended", Callable(self, "_on_drag_ended"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - drag_offset


func _on_drag_started(local_mouse_pos: Vector2) -> void:
	is_dragging = true
	drag_offset = local_mouse_pos


func _on_drag_ended() -> void:
	is_dragging = false


func open() -> void:
	if visible or _is_animating:
		return
	
	_is_animating = true
	visible = true
	await TweenUtils.enlarge_and_fade_in(self, 0.08)
	_is_animating = false


func close() -> void:
	if not visible or _is_animating:
		return
	
	_is_animating = true
	await TweenUtils.shrink_and_fade_out(self, 0.08)
	visible = false
	_is_animating = false


func _on_close_pressed() -> void:
	await close()
	on_close_requested()


func on_close_requested() -> void:
	pass
