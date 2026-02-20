extends Node
class_name TweenUtils


static func fade_in(node: CanvasItem, final_transparency: float, duration: float) -> void:
	node.modulate = Color.TRANSPARENT
	var t := node.create_tween()
	t.tween_property(node, "modulate:a", final_transparency, duration)


static func fade_and_slide_out(node: Control, offset: float, duration: float) -> void:
	var start_x : float = node.global_position.x
	var t := node.create_tween()
	
	t.set_parallel(true)
	t.tween_property(node, "modulate:a", 0.0, duration)
	t.tween_property(node, "global_position:x", start_x + offset, duration)
	t.set_parallel(false)
	
	await t.finished
