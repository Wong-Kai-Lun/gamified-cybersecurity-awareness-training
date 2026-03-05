extends Control

@onready var outbound_hflow: HFlowContainer = $MarginContainer/OutboundHFlow
@onready var file_scene: PackedScene = preload("res://game/main_game/programs/file/file.tscn")
@onready var drop_icon: TextureRect = $TextureRect

var current_email: EmailData


func _ready():
	mouse_exited.connect(_on_mouse_exited)
	_update_drop_field()


func setup(email: EmailData) -> void:
	if current_email and current_email.outbound_updated.is_connected(_on_outbound_updated):
		current_email.outbound_updated.disconnect(_on_outbound_updated)

	current_email = email

	if current_email.email_type == EmailData.EmailType.OUTBOUND:
		if not current_email.outbound_updated.is_connected(_on_outbound_updated):
			current_email.outbound_updated.connect(_on_outbound_updated)

		draw_files(current_email.outbound_attachments)
	else:
		clear_files()


func clear_files() -> void:
	for child in outbound_hflow.get_children():
		child.queue_free()


func draw_files(file_array: Array[FileData]) -> void:
	clear_files()
	
	for file_data in file_array:
		var file_instance := file_scene.instantiate()
		outbound_hflow.add_child(file_instance)
		file_instance.setup(file_data)
		file_instance.remove_requested.connect(_remove_outbound_file_data)
	
	_update_drop_field()


func _on_outbound_updated(outbound_array: Array[FileData]):
	draw_files(outbound_array)


func _update_drop_field():
	if current_email and not current_email.outbound_attachments.is_empty():
		drop_icon.hide()
	else:
		drop_icon.show()


#region Drag & Drop
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = Color(0.0, 1.0, 0.0, 0.34) # Green
	add_theme_stylebox_override("panel", new_stylebox)
	
	return data is FileData


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var outbound_file_data = FileServiceInstance.convert_file_context(data, FileData.FileContext.OUTBOUND)
	current_email.append_file_to_outbound(outbound_file_data)


func _on_mouse_exited() -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = Color(0.0, 0.0, 0.0, 0.07) # Grey
	add_theme_stylebox_override("panel", new_stylebox)
#endregion


func _remove_outbound_file_data(file_data: FileData) -> void:
	current_email.remove_file_from_outbound(file_data)
