extends Control
class_name File

signal remove_requested(file_data: FileData)

@onready var action_menu_button: MenuButton = $ActionMenuButton
@onready var img_texture_rect: TextureRect = $ActionMenuButton/MarginContainer/VBoxContainer/AspectRatioContainer/FileImg
@onready var name_label: Label = $ActionMenuButton/MarginContainer/VBoxContainer/FileName
var file_data: FileData
var is_draggable: bool = true


func setup(data: FileData) -> void:
	file_data = data
	img_texture_rect.texture = data.file_texture
	name_label.text = data.file_name
	
	match data.file_context:
		FileData.FileContext.INBOUND:
			_setup_inbound_file()
		
		FileData.FileContext.INVENTORY:
			_setup_inventory_file()
			
		FileData.FileContext.OUTBOUND:
			_setup_outbound_file()
			
		FileData.FileContext.TRASH:
			pass
			
		_:
			push_warning("Unknown FileContext: %s" % data.context)


# Abstract later.
func _setup_inbound_file() -> void:
	is_draggable = false
	
	var action_menu_popup: PopupMenu = action_menu_button.get_popup()
	action_menu_popup.add_item("Download", 0)
	action_menu_popup.id_pressed.connect(_file_action)


func _setup_inventory_file() -> void:
	is_draggable = true
	
	var action_menu_popup: PopupMenu = action_menu_button.get_popup()
	action_menu_popup.add_item("Delete", 1)
	action_menu_popup.id_pressed.connect(_file_action)


func _setup_outbound_file() -> void:
	is_draggable = false
	
	var action_menu_popup: PopupMenu = action_menu_button.get_popup()
	action_menu_popup.add_item("Remove Attachment", 2)
	action_menu_popup.id_pressed.connect(_file_action)


# Action Menu Logic
func _file_action(id: int) -> void:
	match id:
		0:
			print("Downloaded file: ", file_data.file_name)
			GameManagerInstance.add_file_to_inventory(file_data)
		
		1:
			print("Delete pressed!")
			
		2:
			print("Remove Attachment pressed!")
			_on_remove_requested()


func _on_remove_requested() -> void:
	remove_requested.emit(file_data)
	queue_free()


func _get_drag_data(at_position: Vector2) -> FileData:
	if is_draggable:
		set_drag_preview(_build_drag_preview())
		return file_data
	return


func _build_drag_preview() -> VBoxContainer:
	var preview_texture = TextureRect.new()
	preview_texture.texture = file_data.file_texture
	preview_texture.expand = true
	preview_texture.custom_minimum_size = Vector2(80, 80)
	
	var preview_text_label = Label.new()
	preview_text_label.text = file_data.file_name
	preview_text_label.add_theme_color_override("font_color", Color("#000000"))
	
	var preview_container = VBoxContainer.new()
	var aspect_ratio_container = AspectRatioContainer.new()
	aspect_ratio_container.add_child(preview_texture)
	preview_container.add_child(aspect_ratio_container)
	preview_container.add_child(preview_text_label)
	
	return preview_container
